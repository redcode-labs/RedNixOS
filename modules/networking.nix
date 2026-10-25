{
  config,
  lib,
  ...
}: let
  cfg = config.services.rednixos.networking;
in {
  options.services.rednixos.networking = {
    enable = lib.mkEnableOption "rednixos networking defaults (NetworkManager + firewall + avahi/unbound)";

    # hostName = lib.mkOption {
    #   type = lib.types.str;
    #   default = "RedNixOS";
    #   description = "Hostname applied when this module is enabled.";
    # };

    firewall = {
      allowedTCPPorts = lib.mkOption {
        type = lib.types.listOf lib.types.port;
        default = [22 80];
        description = "TCP ports opened by the rednixos firewall preset.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      # hostName = lib.mkDefault cfg.hostName;
      wireless.enable = lib.mkForce false;
      networkmanager.enable = lib.mkDefault true;
      firewall = {
        allowedTCPPorts = cfg.firewall.allowedTCPPorts;
        allowPing = lib.mkDefault false;
        checkReversePath = lib.mkDefault "loose";
        logReversePathDrops = lib.mkDefault true;
        autoLoadConntrackHelpers = lib.mkDefault false;
        connectionTrackingModules = lib.mkDefault [
          "ftp"
          "irc"
          "sane"
          "sip"
          "tftp"
          "amanda"
          "h323"
          "netbios_sn"
          "pptp"
          "snmp"
        ];
      };
    };

    services = {
      avahi = {
        enable = lib.mkDefault true;
        browseDomains = lib.mkDefault [];
        wideArea = lib.mkDefault false;
        nssmdns4 = lib.mkDefault true;
      };

      unbound = {
        enable = lib.mkDefault true;
        settings.server = {
          access-control = lib.mkDefault [];
          interface = lib.mkDefault [];
        };
      };
    };
  };
}
