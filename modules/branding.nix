{
  config,
  lib,
  ...
}: let
  cfg = config.services.rednixos.branding;
in {
  options.services.rednixos.branding = {
    enable = lib.mkEnableOption "RedNixOS hostname and distro name";
  };

  config = lib.mkIf cfg.enable {
    networking.hostName = lib.mkDefault "rednixos";

    # os-release NAME / PRETTY_NAME, `nixos-version`, boot menu.
    # distroId stays "nixos": tooling special-cases ID=nixos.
    system.nixos.distroName = lib.mkDefault "RedNixOS";
  };
}
