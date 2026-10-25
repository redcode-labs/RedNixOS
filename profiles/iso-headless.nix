{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    ../modules/presets/minimal.nix
    ./branding.nix
    ./determinate.nix
    ./live-kernel.nix
    "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
  ];

  # See profiles/iso.nix - same reason, and this profile sets no edition
  image.baseName = lib.mkForce "rednixos${lib.optionalString (config.isoImage.edition != "") "-${config.isoImage.edition}"}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";

  services.rednixos = {
    networking.enable = lib.mkDefault true;
    installerUser.enable = lib.mkDefault true;
  };

  # See profiles/iso.nix for rationale
  security.sudo.enable = lib.mkForce false;

  boot.loader = {
    systemd-boot.enable = lib.mkDefault true;
    efi.canTouchEfiVariables = lib.mkDefault true;
  };

  virtualisation.docker.enable = lib.mkDefault true;
}
