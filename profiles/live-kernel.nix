# kernel policy for the live ISOs
# shared by iso.nix and iso-headless.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # ZFS: keeping the capability, dropping the integration
  #
  # nixpkgs' profiles/base.nix turns `boot.supportedFilesystems.zfs` on by
  # mkDefault because the installer profile wants to install *onto* ZFS
  #
  # RedNixOS doesn't, as the ISO is a live environment
  # What it needs is to be able to read a target's pools (Proxmox/TrueNAS/etc.),
  # so kernel module is added and operator decides when to load them:
  #
  #   modprobe zfs
  #   zpool import -a -o readonly=on
  #
  # also, it is safer for forensics:
  # with it enabled, zfs-import/zfs-mount units can import pools
  # automatically at boot, and importing read-write replays the ZIL and
  # rewrites labels - i.e. it modifies the evidence

  boot.supportedFilesystems.zfs = false;

  # Resolved through `kernelModuleAttribute` rather than hardcoding `zfs_2_4`,
  # so a ZFS version bump in nixpkgs doesn't silently drop the module.
  boot.extraModulePackages = [
    config.boot.kernelPackages.${pkgs.zfs.kernelModuleAttribute}
  ];

  environment.systemPackages = [pkgs.zfs];
}
