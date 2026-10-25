{lib, ...}: {
  imports = [../.];

  services.rednixos = {
    tools.enable = lib.mkDefault true;
    hardening.enable = lib.mkDefault true;
    networking.enable = lib.mkDefault true;
    graphical.enable = lib.mkDefault true;
    theme.enable = lib.mkDefault true;
    nix-config.enable = lib.mkDefault true;
  };
}
