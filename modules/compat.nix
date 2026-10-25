{
  config,
  lib,
  pkgs,
  rednixos-extras,
  ...
}: let
  cfg = config.services.rednixos.compat;

  rednixos-fhs = pkgs.buildFHSEnv {
    name = "rednixos-fhs";
    targetPkgs = p:
      (p.appimageTools.defaultFhsEnvArgs.targetPkgs p)
      ++ (with p; [
        pkg-config
        ncurses
        zlib
        openssl
        libgcc
        # libstdc++.so.6. Replaces `libstdcxx5` (GCC 3.x's libstdc++.so.5)
        stdenv.cc.cc.lib
        glibc
        gcc
      ]);
    runScript = "bash";
    profile = ''
      export FHS=1
      export PS1="(rednixos-fhs) $PS1"
    '';
  };
in {
  options.services.rednixos.compat = {
    fhs.enable = lib.mkEnableOption "an FHS shim env (`rednixos-fhs`) for running prebuilt non-Nix binaries";
    appimage.enable = lib.mkEnableOption "transparent AppImage execution via binfmt";
    nix-alien.enable = lib.mkEnableOption "nix-alien for runtime dependency resolution of foreign ELFs";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.fhs.enable {
      environment.systemPackages = [rednixos-fhs];
    })

    (lib.mkIf cfg.appimage.enable {
      programs.appimage = {
        enable = true;
        binfmt = true;
      };
    })

    (lib.mkIf cfg.nix-alien.enable {
      environment.systemPackages = [
        rednixos-extras.nix-alien.${pkgs.system}.nix-alien
      ];
    })
  ];
}
