{lib, ...}: {
  imports = [./wsl.nix];

  services.rednixos.tools.enable = lib.mkForce false;

  # seed a matching /etc/nixos: the shared copy enables the full tool
  # collection, which would pull 700+ packages in on a -light user's first rebuild
  wsl.tarball.configPath = lib.mkForce ./wsl-light-etc-nixos;
}
