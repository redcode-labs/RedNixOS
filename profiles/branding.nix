# User-visible identity, shared by every shippable profile
#
# Deliberately NOT a module: importing rednixos as a drop-in should NEVER
# rename somebody's host or relabel their distro
# That only belongs on images 'shipped' by RedNixOS,
# so it lives in profiles/ and is imported by iso.nix,  iso-headless.nix and wsl.nix
# (the -light variants inherit it).
{lib, ...}: {
  networking.hostName = lib.mkDefault "rednixos";

  # Sets os-release NAME / PRETTY_NAME, `nixos-version`, and the boot menu.
  system.nixos.distroName = lib.mkDefault "RedNixOS";

  # `system.nixos.distroId` stays "nixos" on purpose
}
