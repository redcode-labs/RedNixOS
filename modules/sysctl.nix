{
  config,
  lib,
  ...
}: let
  cfg = config.services.rednixos.sysctl;
in {
  options.services.rednixos.sysctl = {
    enable = lib.mkEnableOption "pentest-friendly sysctl + ulimit defaults";

    ipForward = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable `net.ipv4.ip_forward` and `net.ipv6.conf.all.forwarding`
        for transparent-proxy / pivot scenarios. OFF by default.
      '';
    };

    looseRpFilter = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Set reverse-path filtering to "loose" (`= 2`) instead of strict
        (`= 1`). Strict mode drops packets whose return path doesn't
        traverse the receiving interface.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl =
      {
        # Bind <1024 ports as a non-root user
        "net.ipv4.ip_unprivileged_port_start" = 0;

        # Wider ephemeral range for high-fanout scanners
        "net.ipv4.ip_local_port_range" = "15000 65535";

        # Connection backlog ceilings raised so masscan-style fanout
        # doesn't drop SYNs at the kernel.
        "net.core.somaxconn" = 8192;
        "net.core.netdev_max_backlog" = 65536;

        # File descriptor / inotify ceilings raised so long-running tools
        # (Burp, mitmproxy, BloodHound ingestion) don't hit EMFILE
        "fs.inotify.max_user_watches" = 524288;
        "fs.file-max" = 2097152;

        # Required by some sandbox-using tools (nix-alien, appimages)
        "kernel.unprivileged_userns_clone" = 1;
      }
      // lib.optionalAttrs cfg.looseRpFilter {
        "net.ipv4.conf.all.rp_filter" = 2;
        "net.ipv4.conf.default.rp_filter" = 2;
      }
      // lib.optionalAttrs cfg.ipForward {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };

    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "1048576";
      }
      {
        domain = "*";
        type = "hard";
        item = "nofile";
        value = "1048576";
      }
    ];
  };
}
