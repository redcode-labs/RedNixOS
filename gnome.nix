{
  pkgs,
  self,
  lib,
  ...
}: let
  # generate wallpaper entry (copied from pkgs.nixos-artwork)
  rednixos-wallpaper = import ./wallpapers.nix {
    inherit (pkgs) stdenv;
    inherit lib self;
  };

  # force custom wallpaper
  nixos-gsettings-desktop-schemas = pkgs.gnome.nixos-gsettings-overrides.override {
    nixos-background-dark = rednixos-wallpaper;
    nixos-background-light = rednixos-wallpaper;
  };

  # custom wallpaper
  background-info = pkgs.writeTextFile {
    name = "rednixos-background-info";
    text = ''
      <?xml version="1.0"?>
      <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
      <wallpapers>
        <wallpaper deleted="false">
          <name>RedNixOS</name>
          <filename>${self}/home/RedNixOSWallpaper.png</filename>
          <filename-dark>${self}/home/RedNixOSWallpaper.png</filename-dark>
          <options>zoom</options>
          <shade_type>solid</shade_type>
          <pcolor>#3a4ba0</pcolor>
          <scolor>#2f302f</scolor>
        </wallpaper>
      </wallpapers>
    '';
    destination = "/share/gnome-background-properties/rednixos.xml";
  };
in {
  environment = {
    systemPackages = with pkgs; [
      background-info

      libsForQt5.kpmcore
      calamares-nixos
      calamares-nixos-extensions
      # Get list of locales
      glibcLocales
    ];

    variables = {
      # Override GSettings schemas
      NIX_GSETTINGS_OVERRIDES_DIR = lib.mkForce "${nixos-gsettings-desktop-schemas}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";
      # Fix scaling for calamares on wayland
      QT_QPA_PLATFORM = "$([[ $XDG_SESSION_TYPE = \"wayland\" ]] && echo \"wayland\")";
    };
  };

  isoImage.edition = "gnome";

  # Theme calamares with GNOME theme
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  services.xserver.desktopManager.gnome = {
    enable = true;

    # Add Firefox and other tools useful for installation to the launcher
    favoriteAppsOverride = lib.mkForce ''
      [org.gnome.shell]
      favorite-apps=[ 'firefox.desktop', 'nixos-manual.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', 'gparted.desktop', 'io.calamares.calamares.desktop' ]
    '';

    # Override GNOME defaults to disable GNOME tour and disable suspend
    extraGSettingsOverrides = ''
      [org.gnome.shell]
      welcome-dialog-last-shown-version='9999999999'
      [org.gnome.desktop.session]
      idle-delay=0
      [org.gnome.settings-daemon.plugins.power]
      sleep-inactive-ac-type='nothing'
      sleep-inactive-battery-type='nothing'
    '';

    extraGSettingsOverridePackages = [pkgs.gnome-settings-daemon];
  };
}
