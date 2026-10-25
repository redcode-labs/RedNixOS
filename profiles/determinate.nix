# Determinate Nix profile
{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.determinate.nixosModules.default];
  determinate.enable = lib.mkDefault true;
}
