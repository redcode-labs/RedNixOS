{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
    modulesPath = "${nixpkgs}/nixos/modules";

    mkSystem = extraModules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {inherit inputs self;};

        modules = [./rednixos-iso.nix] ++ extraModules;
      };
  in {
    nixosConfigurations = let
      packages = {pkgs, ...}: {environment.systemPackages = nixpkgs.lib.attrValues inputs.rednix.packages.${pkgs.system};};
    in {
      RedNixOS = mkSystem [
        ./gnome.nix
        ./graphical.nix
        packages
        "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
      ];
      RedNixOS-light = mkSystem [
        ./gnome.nix
        ./graphical.nix
        "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
      ];
      RedNixOS-headless = mkSystem [
        packages
        "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
      ];
    };

    packages.x86_64-linux =
      (builtins.mapAttrs (n: v: v.config.system.build.isoImage) self.nixosConfigurations)
      // {
        default = self.packages.x86_64-linux.RedNixOS;
      };
  };
}
