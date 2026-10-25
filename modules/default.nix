{...}: {
  imports = [
    ./tools.nix
    ./hardening.nix
    ./networking.nix
    ./graphical.nix
    ./theme.nix
    ./installer-user.nix
    ./nix-config.nix
    ./datasets.nix
    ./compat.nix
    ./sysctl.nix
    ./nur.nix
    ./services
  ];
}
