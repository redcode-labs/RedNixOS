{
  config,
  lib,
  ...
}: let
  cfg = config.services.rednixos.installerUser;
in {
  options.services.rednixos.installerUser = {
    enable = lib.mkEnableOption ''
      the default `red` user with password `rednixos`.

      Intended ONLY for live ISO and WSL images.
    '';

    name = lib.mkOption {
      type = lib.types.str;
      default = "red";
      description = "Login name of the default user.";
    };

    initialPassword = lib.mkOption {
      type = lib.types.str;
      default = "rednixos";
      description = "Initial password (changeable on first login).";
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "input"
        "docker"
      ];
      description = "Groups the installer user belongs to.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.name} = {
      isNormalUser = true;
      description = "Red";
      inherit (cfg) initialPassword;
      inherit (cfg) extraGroups;
    };
  };
}
