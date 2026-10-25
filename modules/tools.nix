{
  config,
  lib,
  pkgs,
  rednix-pkgs,
  rednix-by-category,
  ...
}: let
  cfg = config.services.rednixos.tools;
in {
  options.services.rednixos.tools = {
    enable = lib.mkEnableOption "the rednix offensive-security tool collection";

    # `packages` and `categories` combined serve as a combo
    # WHEN both are non-empty
    # When both are null (default), every package available for the
    # current system is installed

    packages = lib.mkOption {
      type = with lib.types; nullOr (listOf str);
      default = null;
      example = ["nmap" "ffuf" "sqlmap"];
      description = ''
        Restrict by package name (matches rednix's `packages.<system>` keys,
        i.e. pnames). Names not present in rednix are silently dropped.
      '';
    };

    categories = lib.mkOption {
      type = with lib.types; nullOr (listOf str);
      default = null;
      example = ["web" "passwords" "info-gathering"];
      description = ''
        Restrict by rednix category (matches the keys of rednix's
        `packagesByCategory.<system>` output - e.g. `web`, `passwords`,
        `forensics`, `wireless`, …). Unknown categories are silently
        dropped.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = let
      sys = pkgs.system;
      flat = rednix-pkgs.${sys} or {};
      byCat = rednix-by-category.${sys} or {};

      fromNames =
        if cfg.packages == null
        then []
        else lib.attrValues (lib.filterAttrs (n: _: builtins.elem n cfg.packages) flat);

      fromCats =
        if cfg.categories == null
        then []
        else lib.flatten (lib.attrValues (lib.filterAttrs (n: _: builtins.elem n cfg.categories) byCat));
    in
      if cfg.packages == null && cfg.categories == null
      then lib.attrValues flat
      else lib.unique (fromNames ++ fromCats);
  };
}
