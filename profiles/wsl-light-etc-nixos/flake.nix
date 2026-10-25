# Seeded into the RedNixOS WSL tarball as /etc/nixos/flake.nix.
#
# Without this file NixOS-WSL seeds its own generic configuration.nix, which
# imports <nixos-wsl/modules> and nothing else
{
  description = "RedNixOS on WSL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rednixos = {
      url = "github:redcode-labs/RedNixOS/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixos-wsl,
    rednixos,
    ...
  }: {
    nixosConfigurations.rednixos = nixpkgs.lib.nixosSystem {
      # Change to "aarch64-linux" if you imported an ARM image
      system = "x86_64-linux";

      modules = [
        nixos-wsl.nixosModules.default
        rednixos.nixosModules.minimal

        (
          {
            config,
            lib,
            ...
          }: {
            wsl = {
              enable = true;
              defaultUser = "red";
              startMenuLaunchers = true;
            };

            # the -light image ships no tools
            # use .#wsl for image with all the tooling
            services.rednixos.tools.enable = false;

            # the WSL kernel carries no audit subsystem
            # and NixOS-WSL's default user has no password
            # so polkit has nothing to prompt for
            # hence passwordless wheel via run0's polkit rule AND the
            # `sudo` shim, rather than a setuid sudo

            # mirrors profiles/wsl.nix, so keeping the two in step
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
