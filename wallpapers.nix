# Build a wallpaper package that exposes the RedNixOS wallpaper at the
# paths GNOME and KDE expect, plus a gnome-background-properties XML so
# Settings → Appearance lists it as a selectable wallpaper.
#
# Pattern lifted from `pkgs.nixos-artwork`, but flattened: the original
# wraps `src` in an inner derivation, which (in our case) produces a
# directory rather than a file - the resulting symlink under
# /share/backgrounds/nixos resolves to a directory path that GNOME
# can't load as an image. We copy the file directly instead.
{
  lib,
  stdenv,
  self,
}: let
  name = "rednixos";
  fileName = "RedNixOSWallpaper.png";
  source = "${self}/home/${fileName}";
in
  stdenv.mkDerivation {
    pname = "rednixos-wallpaper";
    version = "1.0";

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/backgrounds/nixos
      cp ${source} $out/share/backgrounds/nixos/${fileName}

      mkdir -p $out/share/gnome-background-properties
      cat > $out/share/gnome-background-properties/${name}.xml <<EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
      <wallpapers>
        <wallpaper deleted="false">
          <name>RedNixOS</name>
          <filename>$out/share/backgrounds/nixos/${fileName}</filename>
          <filename-dark>$out/share/backgrounds/nixos/${fileName}</filename-dark>
          <options>zoom</options>
          <shade_type>solid</shade_type>
          <pcolor>#e93d58</pcolor>
          <scolor>#1b1e20</scolor>
        </wallpaper>
      </wallpapers>
      EOF

      mkdir -p $out/share/wallpapers/${name}/contents/images
      cp ${source} $out/share/wallpapers/${name}/contents/images/${fileName}
      cat > $out/share/wallpapers/${name}/metadata.desktop <<EOF
      [Desktop Entry]
      Name=RedNixOS
      X-KDE-PluginInfo-Name=${name}
      EOF
    '';

    passthru = {
      gnomePath = "share/backgrounds/nixos/${fileName}";
      kdePath = "share/wallpapers/${name}/contents/images/${fileName}";
    };

    meta = with lib; {
      description = "RedNixOS Wallpaper";
      license = licenses.free;
      platforms = platforms.all;
    };
  }
