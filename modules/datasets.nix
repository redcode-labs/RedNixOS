{
  config,
  lib,
  pkgs,
  rednixos-sources,
  ...
}: let
  cfg = config.services.rednixos.datasets;

  # systemd-tmpfiles `L+` rule: create (or replace) a symlink at <dest>
  # pointing at <src>. Used to surface read-only Nix store paths under
  # the Kali-convention /usr/share locations pentest tooling expects.
  link = src: dest: "L+ ${dest} - - - - ${src}";
in {
  options.services.rednixos.datasets = {
    wordlists = {
      enable = lib.mkEnableOption "SecLists + nixpkgs wordlists at /usr/share/wordlists";
    };

    payloads = {
      enable = lib.mkEnableOption "PayloadsAllTheThings + ExploitDB at /usr/share/payloads";
    };

    webshells = {
      enable = lib.mkEnableOption "the Red-Flake webshells collection at /usr/share/webshells";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.wordlists.enable {
      environment.systemPackages = [pkgs.seclists];
      systemd.tmpfiles.rules = [
        (link "${pkgs.seclists}/share/wordlists/SecLists" "/usr/share/wordlists/SecLists")
      ];
    })

    (lib.mkIf cfg.payloads.enable {
      environment.systemPackages = [pkgs.exploitdb];
      systemd.tmpfiles.rules = [
        (link "${rednixos-sources.payloadsallthethings}" "/usr/share/payloads/PayloadsAllTheThings")
        (link "${pkgs.exploitdb}/share/exploitdb" "/usr/share/payloads/exploitdb")
      ];
    })

    (lib.mkIf cfg.webshells.enable {
      systemd.tmpfiles.rules = [
        (link "${rednixos-sources.webshells}" "/usr/share/webshells")
      ];
    })
  ];
}
