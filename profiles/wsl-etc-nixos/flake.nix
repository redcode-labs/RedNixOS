# Seeded into the RedNixOS WSL tarball as /etc/nixos/flake.nix.
# `nixos-rebuild switch` picks this up automatically - the attribute below is
# named for the image hostname (rednixos), so no --flake argument is needed.
#
# Must stay a plain source file: wsl.tarball.configPath is read with
# lib.cleanSource at eval time, so a derivation path fails there.
{
  description = "RedNixOS on WSL";

  inputs = {
    rednixos.url = "github:redcode-labs/RedNixOS/v1.0.1";

    # Determinate Nix, as the image ships. Added here because it comes from
    # profiles/ upstream, which drop-in consumers cannot reach.
    determinate.url = "github:DeterminateSystems/determinate";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "rednixos/nixpkgs";
    };
  };

  outputs = {
    rednixos,
    nixos-wsl,
    determinate,
    ...
  }: let
    nixpkgs = rednixos.inputs.nixpkgs;
  in {
    nixosConfigurations.rednixos = nixpkgs.lib.nixosSystem {
      # Change to "aarch64-linux" if you imported an ARM image.
      system = "x86_64-linux";

      modules = [
        nixos-wsl.nixosModules.default
        rednixos.nixosModules.minimal
        determinate.nixosModules.default

        (
          {
            config,
            lib,
            ...
          }: {
            # Hostname + os-release name, matching the image.
            services.rednixos.branding.enable = true;

            wsl = {
              enable = true;
              defaultUser = "red";
              startMenuLaunchers = true;
            };

            # The full rednix collection. Narrow with
            # services.rednixos.tools.packages or .categories.
            services.rednixos.tools.enable = true;

            # No audit subsystem in the WSL kernel; and the default user has
            # no password, so polkit cannot prompt - passwordless wheel via
            # run0 instead of a setuid sudo.
            security.audit.enable = lib.mkForce false;
            security.auditd.enable = lib.mkForce false;
            security.run0.wheelNeedsPassword = lib.mkForce false;

            system.stateVersion = config.system.nixos.release;
          }
        )
      ];
    };
  };
}
