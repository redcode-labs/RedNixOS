# kernel policy for the live ISOs
# shared by iso.nix and iso-headless.nix
{
  lib,
  pkgs,
  ...
}: {
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # ZFS dropped for now: zfs 2.4.4 is marked broken against kernel 7.3, so
  # shipping the module stops the ISO building at all. 
  # Seems more important to have driver support on unknown/new hardware
  # rather than have niche feature like that enabled by default.
  #
  # You can re-add both lines below once
  # `linuxPackages_latest.${pkgs.zfs.kernelModuleAttribute}` is no longer
  # broken (needs `config` back in the argument set):
  #
  #   boot.extraModulePackages = [
  #     config.boot.kernelPackages.${pkgs.zfs.kernelModuleAttribute}
  #   ];
  #   environment.systemPackages = [pkgs.zfs];

  # tl;dr no ZFS pool access from the ISO. `zpool import` needs
  # zfs.ko and there is no userspace fallback.
  
  boot.supportedFilesystems.zfs = false;
}
