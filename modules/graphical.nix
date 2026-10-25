{
  config,
  lib,
  ...
}: let
  cfg = config.services.rednixos.graphical;
in {
  options.services.rednixos.graphical = {
    enable = lib.mkEnableOption "rednixos graphical stack (plymouth, pipewire, xserver)";
  };

  config = lib.mkIf cfg.enable {
    boot.plymouth.enable = lib.mkDefault true;

    hardware = {
      graphics.enable = lib.mkDefault true;
      bluetooth.enable = lib.mkDefault true;
    };

    services = {
      pipewire = {
        enable = lib.mkDefault true;
        pulse.enable = lib.mkDefault true;
      };

      # pipewire-pulse replaces pulseaudio; the two conflict,
      # keeping the daemon off even if a downstream profile enables it.
      pulseaudio.enable = lib.mkForce false;

      printing.enable = lib.mkDefault true;
      libinput.enable = lib.mkDefault true;

      xserver = {
        enable = lib.mkDefault true;
        xkb = {
          layout = lib.mkDefault "us";
          variant = lib.mkDefault "";
        };
      };

      hardware.bolt.enable = lib.mkDefault true;
      spice-vdagentd.enable = lib.mkDefault true;
      qemuGuest.enable = lib.mkDefault true;
    };

    virtualisation = {
      hypervGuest.enable = lib.mkDefault true;
      vmware.guest.enable = lib.mkDefault true;
    };
  };
}
