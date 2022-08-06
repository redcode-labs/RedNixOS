{
  config,
  pkgs,
  lib,
  pkgs21_11,
  ...
}: {
  environment.systemPackages = [
    pkgs21_11.hello
  ];

  # use soystemd-boot EFI boot loader
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
    };
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
      passwordAuthentication = false;
      allowSFTP = true;
      kbdInteractiveAuthentication = false;
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

    hardware = {
      bolt.enable = true;
    };

    spice-vdagentd.enable = true;
    qemuGuest.enable = true;
  };

  virtualisation.docker.enable = true;

  virtualisation.vmware.guest.enable = true;
  virtualisation.hypervGuest.enable = true;
  virtualisation.virtualbox.guest.enable = false;

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

  time.timeZone = "UTC"; # change to your one

  # locales as well
  i18n = rec {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };
  };

  # default user config
  users.users.red = {
    isNormalUser = true;
    home = "/home/red";
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
      allowed-users = ["@wheel"]; #locks down access to nix-daemon
    };
  };

  # nixpkgs config
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    allowInsecurePredicate = p: true;
  };

  # the version of NixOS around which RedNixOS will be built
  system = {
    stateVersion = "22.11";
  };
}
