{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.rednixos.services.bloodhound;
in {
  options.services.rednixos.services.bloodhound = {
    enable = lib.mkEnableOption "BloodHound Community Edition (CE)";

    autostartNeo4j = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        When true, also enables `services.rednixos.services.neo4j`.
        BloodHound is useless without a Neo4j to query, so the default
        is to bring one up alongside.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # The Python ingestor is `pkgs.bloodhound-py`; add it here if you want
    # collection from this host. Note `services.rednixos.tools.enable`
    # already installs both, since rednix's collection selects them too.
    environment.systemPackages = [pkgs.bloodhound-ce];

    services.rednixos.services.neo4j.enable = lib.mkIf cfg.autostartNeo4j true;
  };
}
