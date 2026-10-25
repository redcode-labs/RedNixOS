{
  config,
  lib,
  ...
}: let
  cfg = config.services.rednixos.services.neo4j;
in {
  options.services.rednixos.services.neo4j = {
    enable = lib.mkEnableOption "Neo4j (BloodHound-compatible defaults)";
  };

  config = lib.mkIf cfg.enable {
    services.neo4j = {
      enable = true;
      # BloodHound and most ingestion tools expect bolt on 7687 +
      # browser on 7474, default in nixpkgs but pinned explicitly
      bolt = {
        enable = true;
        listenAddress = lib.mkDefault "127.0.0.1:7687";
      };
      http = {
        enable = true;
        listenAddress = lib.mkDefault "127.0.0.1:7474";
      };
    };

    # NOTE: BloodHound-CE pins Neo4j 4.4.x with specific GDS/APOC
    # plugin versions. Current nixpkgs ships Neo4j 5.x, the community-
    # edition workflows still work, BloodHound-CE may not. If you need
    # the legacy stack, override `services.neo4j.package` and supply the
    # plugin JARs yourself
  };
}
