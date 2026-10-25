{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.services.rednixos.theme;

  # Builds a derivation that installs the wallpaper PNG under the
  # GNOME (`/share/backgrounds/nixos/`) expected path,
  # plus a `gnome-background-properties` XML so the picker in
  # Settings → Appearance shows it as a selectable wallpaper.
  # Exposes `passthru.gnomeFilePath` for use in GSettings overrides.
  rednixos-wallpaper = import ../wallpapers.nix {
    inherit (pkgs) stdenv;
    inherit lib self;
  };

  wallpaperUri = "file://${rednixos-wallpaper}/${rednixos-wallpaper.gnomePath}";

  # The RedNixOS palette: near-black greys with a red accent
  accent = "#e93d58";
  backdrop = "#1b1e20";
in {
  options.services.rednixos.theme = {
    enable = lib.mkEnableOption "rednixos GNOME theming + wallpaper";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [rednixos-wallpaper];

    services.desktopManager.gnome.enable = lib.mkDefault true;

    # Applied through the system dconf database, NOT
    # `services.desktopManager.gnome.extraGSettingsOverrides`
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          # Dark by default, with the red accent. `color-scheme` is what
          # libadwaita apps follow; `gtk-theme` is the fallback for older
          # GTK3 apps that ignore it. `accent-color` is GNOME 47+
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = "Adwaita-dark";
            accent-color = "red";
          };

          "org/gnome/desktop/background" = {
            picture-uri = wallpaperUri;
            picture-uri-dark = wallpaperUri;
            picture-options = "zoom";
            primary-color = accent;
            secondary-color = backdrop;
          };

          "org/gnome/desktop/screensaver" = {
            picture-uri = wallpaperUri;
            primary-color = accent;
            secondary-color = backdrop;
          };
        };
      }
    ];

    programs.dconf.profiles.gdm.databases = [
      {
        settings."org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          accent-color = "red";
        };
      }
    ];
  };
}
