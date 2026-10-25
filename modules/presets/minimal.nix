{lib, ...}: {
  imports = [../.];

  services.rednixos = {
    tools.enable = lib.mkDefault true;
    hardening.enable = lib.mkDefault true;
    nix-config.enable = lib.mkDefault true;
  };
}
