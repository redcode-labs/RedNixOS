{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.rednixos.nix-config;
in {
  options.services.rednixos.nix-config = {
    enable = lib.mkEnableOption "rednixos nix daemon defaults (flakes, allowUnfree, allowInsecure)";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      package = lib.mkDefault pkgs.nixVersions.git;
      settings = {
        extra-experimental-features = ["nix-command" "flakes"];
        allowed-users = lib.mkDefault ["@wheel"];
      };
    };

    nixpkgs.config = {
      allowUnfree = lib.mkDefault true;
      allowInsecurePredicate = lib.mkDefault (_: true);
      segger-jlink.acceptLicense = lib.mkDefault true;
    };
  };
}
