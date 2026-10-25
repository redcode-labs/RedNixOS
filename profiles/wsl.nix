{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../modules/presets/minimal.nix
    ./branding.nix
    ./determinate.nix
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = lib.mkDefault "red";
    startMenuLaunchers = lib.mkDefault true;

    # seed /etc/nixos inside the tarball, so a user's first
    # `nixos-rebuild switch` rebuilds RedNixOS instead of the generic
    # NixOS-WSL config
    #
    # must be a source path, not a derivation:
    # NixOS-WSL reads it with `lib.cleanSource` during evaluation,
    # and a store path that hasn't been
    # built yet fails with "path is not valid"
    tarball.configPath = lib.mkDefault ./wsl-etc-nixos;
  };

  # WSL kernel doesn't carry the audit subsystem.
  security.audit.enable = lib.mkForce false;
  security.auditd.enable = lib.mkForce false;

  # NixOS-WSL's default user has no password, so polkit has no credential to
  # prompt for, so instead of bringing back a setuid sudo, grant wheel
  # passwordless escalation through run0's own polkit rule
  #
  # the `sudo` shim itself comes from modules/hardening.nix, on every profile
  # only the passwordless part is WSL-specific
  #
  # if this misbehaves under NixOS-WSL's systemd shim, escalation is still
  # reachable out-of-band from Windows via `wsl -d <distro> -u root`, so a
  # broken polkit rule can't lock you out of the image
  security.run0.wheelNeedsPassword = lib.mkForce false;

  system.stateVersion = lib.mkDefault config.system.nixos.release;
}
