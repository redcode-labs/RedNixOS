{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-21_11.url = "github:NixOS/nixpkgs/nixos-unstable";
    rednix = {
      url = "github:redcode-labs/RedNix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    mkSystem = extraModules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = let
          modulesPath = "${nixpkgs}/nixos/modules";
        in
          [
            {
              _module.args = {
                inherit inputs self;
                pkgs21_11 = import inputs.nixpkgs-21_11 {
                  system = "x86_64-linux";
                  config.allowUnfree = true;
                };
              };
            }
            "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
            # Provide an initial copy of the NixOS channel so that the user
            # doesn't need to run "nix-channel --update" first.
            "${modulesPath}/installer/cd-dvd/channel.nix"

            ./rednixos-iso-unstable.nix
          ]
          ++ extraModules;
      };
  in {
    nixosConfigurations = let
      packages = {pkgs, ...}: {environment.systemPackages = nixpkgs.lib.attrValues inputs.rednix.packages.${pkgs.system};};
    in {
      "RedNixOS-xfce" = mkSystem [
        ./xfce.nix
        packages
      ];
      "RedNixOS-xfce-light" = mkSystem [
        ./xfce.nix
      ];
      "RedNixOS-kde" = mkSystem [
        ./kde.nix
        packages
      ];
      "RedNixOS-kde-light" = mkSystem [
        ./kde.nix
      ];
    };

    packages."x86_64-linux" =
      (builtins.mapAttrs (n: v: v.config.system.build.isoImage) self.nixosConfigurations)
      // {
        default = self.packages."x86_64-linux"."RedNixOS-kde";
      };
  };
}
