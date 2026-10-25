{
  config,
  lib,
  ...
}: let
  cfg = config.services.rednixos.hardening;
in {
  options.services.rednixos.hardening = {
    enable = lib.mkEnableOption "rednixos sshd / privilege-escalation / audit hardening";

    auditExecve = lib.mkEnableOption ''
      an audit rule logging every `execve`.

      Off by default: it records one audit event per process exec
      `auditd` is still enabled, so turn this on when you need an exec trail
    '';
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = lib.mkDefault true;
      allowSFTP = lib.mkDefault true;
      settings = {
        AllowAgentForwarding = lib.mkDefault false;
        AllowStreamLocalForwarding = lib.mkDefault false;
        AllowTcpForwarding = lib.mkDefault true;
        AuthenticationMethods = lib.mkDefault "publickey";
        KbdInteractiveAuthentication = lib.mkDefault false;
        PasswordAuthentication = lib.mkDefault false;
        # ON for remote GUI tooling (Burp, Wireshark) over `ssh -X`
        # the Wayland-only stance applies to local sessions;
        # forwarding here is for reaching tools on this box from elsewhere
        X11Forwarding = lib.mkDefault true;
      };
    };

    security = {
      # escalation goes through `run0` (systemd 256+) rather than sudo
      # `sudo-shim` puts a `sudo` command back on PATH, backed by run0
      sudo.enable = lib.mkDefault false;
      sudo-rs.enable = lib.mkDefault false;

      run0 = {
        enable = lib.mkDefault true;
        sudo-shim.enable = lib.mkDefault true;

        # authenticate once per session rather than once per command
        # polkit keeps the grant for the session (timeout is
        # `security.polkit.settings.Polkitd.ExpirationSeconds`)
        # `enableRemote` stays OFF
        persistentAuth.enable = lib.mkDefault true;
      };

      # run0 forces polkit on itself; this only covers someone disabling
      # run0 while leaving hardening enabled, since run0 fails closed
      # without polkit
      polkit.enable = lib.mkDefault true;

      auditd.enable = lib.mkDefault true;
      audit = {
        enable = lib.mkDefault true;
        rules = lib.mkIf cfg.auditExecve (lib.mkDefault ["-a exit,always -F arch=b64 -S execve"]);
      };
    };
  };
}
