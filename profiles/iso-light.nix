{lib, ...}: {
  imports = [./iso.nix];

  services.rednixos.tools.enable = lib.mkForce false;
}
