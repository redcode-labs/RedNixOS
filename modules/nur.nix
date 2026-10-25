{
  config,
  lib,
  ...
}: let
  cfg = config.services.rednixos.nur;
in {
  options.services.rednixos.nur = {
    enable = lib.mkEnableOption "the Nix User Repository (NUR) overlay as `pkgs.nur`";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      config._module.args.rednixos-extras.nurOverlay
    ];
  };
}
