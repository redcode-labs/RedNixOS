{
  pkgs,
  lib,
  ...
}: {
  # use soystemd-boot EFI boot loader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    opengl.enable = true;
    # disable pulse since we're using pipewire
    pulseaudio.enable = lib.mkForce false;
  };

  services = {
    timesyncd = {
      # feel free to change to sth around your location
      # servers = ["pl.pool.ntp.org"];
    };

    printing.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";
      libinput.enable = true;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    openssh = {
      enable = true;
      allowSFTP = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
      extraConfig = ''
        AllowTcpForwarding yes
        X11Forwarding no
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
      '';
    };

    avahi = {
      enable = true;
      browseDomains = [];
      wideArea = false;
      nssmdns = true;
    };

    unbound = {
      enable = true;
      settings.server = {
        access-control = [];
        interface = [];
      };
    };

    # using VPN is generally a good idea
    # use Mullvad btw
    # mullvad-vpn.enable = true;

    hardware.bolt.enable = true;

    spice-vdagentd.enable = true;
    qemuGuest.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    hypervGuest.enable = true;
    virtualbox.guest.enable = false;
    vmware.guest.enable = true;
  };

  # networking better than on LinkedIn
  networking = {
    hostName = "RedNixOS";
    proxy = {
      # default = "http://user:password@proxy:port/";
      # noProxy = "127.0.0.1,localhost,internal.domain";
    };
    wireless.enable = lib.mkForce false;
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [22 80];
      allowPing = false;
      checkReversePath = "loose";
      logReversePathDrops = true;
      autoLoadConntrackHelpers = false;
      connectionTrackingModules = [
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
      # trustedInterfaces = [ "" ];
    };
  };

  security = {
    # if you want, you can disable sudo and use doas
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
      execWheelOnly = true;
    };
    # apparmor.enable = true;
    # lockKernelModules = true;
    auditd.enable = true;
    audit = {
      enable = true;
      rules = ["-a exit, always -F arch=b64 -s execve"];
    };
  };

  time.timeZone = "UTC"; # change to your timezone

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = ["en_GB.UTF-8/UTF-8"]; # saves 200MB of space
  };

  # default user config
  users.users.red = {
    isNormalUser = true;
    description = "Red";
    initialPassword = "rednixos";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
      "docker"
    ];
  };

  # nix config
  nix = {
    package = pkgs.nixUnstable;
    settings = {
      extra-experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = ["@wheel"]; # locks down access to nix-daemon
    };
  };

  # nixpkgs config
  nixpkgs.config = {
    allowUnfree = true;
    # allowBroken = true;
    allowInsecurePredicate = p: true;
  };

  # the system state version of NixOS. database schemas and other settings will
  # depend on this. do NOT change unless you know what you're doing.
  system.stateVersion = "23.05";
}
