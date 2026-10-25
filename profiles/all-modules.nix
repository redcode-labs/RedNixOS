# eval-coverage target
#
# datasets, compat, sysctl, nur and the neo4j/bloodhound services are off in
# both presets and every real profile, so nothing in `nix flake check` ever
# evaluated a line of their `config` blocks
#
# turning everything on in one config means the existing gate covers
# them, because `nix flake check` evaluates every nixosConfiguration.
#
# keeping this maximal: if you add a module, enable it here too
{lib, ...}: {
  imports = [../modules/presets/full.nix];

  services.rednixos = {
    datasets = {
      wordlists.enable = lib.mkDefault true;
      payloads.enable = lib.mkDefault true;
      webshells.enable = lib.mkDefault true;
    };

    compat = {
      fhs.enable = lib.mkDefault true;
      appimage.enable = lib.mkDefault true;
      nix-alien.enable = lib.mkDefault true;
    };

    sysctl.enable = lib.mkDefault true;
    nur.enable = lib.mkDefault true;

    services = {
      neo4j.enable = lib.mkDefault true;
      bloodhound.enable = lib.mkDefault true;
    };
  };

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };
  boot.loader.grub.devices = ["/dev/vda"];
  system.stateVersion = "26.11";
}
