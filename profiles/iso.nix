{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    ../modules/presets/full.nix
    ./branding.nix
    ./determinate.nix
    ./live-kernel.nix
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
  ];

  # otherwise the published artifact is called nixos-gnome-<label>.iso
  image.baseName = lib.mkForce "rednixos${lib.optionalString (config.isoImage.edition != "") "-${config.isoImage.edition}"}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";

  services.rednixos.installerUser.enable = lib.mkDefault true;

  # nixpkgs' installation-device profile re-enables sudo at mkDefault;
  # override so the hardening intent (run0 + polkit) wins on the live .iso
  security.sudo.enable = lib.mkForce false;

  boot.loader = {
    systemd-boot.enable = lib.mkDefault true;
    efi.canTouchEfiVariables = lib.mkDefault true;
  };

  virtualisation.docker.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    kdePackages.kpmcore
    calamares-nixos
    calamares-nixos-extensions
    glibcLocales
  ];

  environment.variables.QT_QPA_PLATFORM = "$([[ $XDG_SESSION_TYPE = \"wayland\" ]] && echo \"wayland\")";

  isoImage.edition = "gnome";

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  services.desktopManager.gnome = {
    favoriteAppsOverride = lib.mkForce ''
      [org.gnome.shell]
      favorite-apps=[ 'firefox.desktop', 'nixos-manual.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', 'gparted.desktop', 'io.calamares.calamares.desktop' ]
    '';
  };

  # `idle-delay` is gschema type 'u', so it needs an explicit uint32; a bare
  # 0 would serialize as int32 and fail to match the schema
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/shell".welcome-dialog-last-shown-version = "9999999999";

        "org/gnome/desktop/session".idle-delay = lib.gvariant.mkUint32 0;

        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-battery-type = "nothing";
        };
      };
    }
  ];
}
