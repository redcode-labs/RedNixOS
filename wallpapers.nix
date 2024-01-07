# generate wallpaper entries (copied from pkgs.nixos-artwork)
{
  lib,
  stdenv,
  self,
}: let
  mkNixBackground = {
    name,
    src,
    description,
  }: let
    pkg = stdenv.mkDerivation {
      inherit name src;

      dontUnpack = true;

      installPhase = ''
                # GNOME
                mkdir -p $out/share/backgrounds/nixos
                ln -s $src $out/share/backgrounds/nixos/${src.name}

                mkdir -p $out/share/gnome-background-properties/
                cat <<EOF > $out/share/gnome-background-properties/${name}.xml
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
        <wallpapers>
          <wallpaper deleted="false">
            <name>${name}</name>
            <filename>${src}</filename>
            <options>zoom</options>
            <shade_type>solid</shade_type>
            <pcolor>#ffffff</pcolor>
            <scolor>#000000</scolor>
          </wallpaper>
        </wallpapers>
        EOF

                # TODO: is this path still needed?
                mkdir -p $out/share/artwork/gnome
                ln -s $src $out/share/artwork/gnome/${src.name}

                # KDE
                mkdir -p $out/share/wallpapers/${name}/contents/images
                ln -s $src $out/share/wallpapers/${name}/contents/images/${src.name}
                cat >>$out/share/wallpapers/${name}/metadata.desktop <<_EOF
        [Desktop Entry]
        Name=${name}
        X-KDE-PluginInfo-Name=${name}
        _EOF
      '';

      passthru = {
        gnomeFilePath = "${pkg}/share/backgrounds/nixos/${src.name}";
        kdeFilePath = "${pkg}/share/wallpapers/${name}/contents/images/${src.name}";
      };

      meta = with lib; {
        inherit description;
        homepage = "https://github.com/NixOS/nixos-artwork";
        license = licenses.free;
        platforms = platforms.all;
      };
    };
  in
    pkg;
in
  mkNixBackground {
    name = "rednixos";
    description = "RedNixOS Wallpaper";
    src = stdenv.mkDerivation {
      name = "rednixos.png";
      buildCommand = ''
        mkdir -p $out
        cp ${self}/home/RedNixOSWallpaper.png $out/
      '';
    };
  }
