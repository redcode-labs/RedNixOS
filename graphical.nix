{lib, ...}: {
  boot.plymouth.enable = true;

  hardware = {
    graphics.enable = true;
    # disable pulse since we're using pipewire
    pulseaudio.enable = lib.mkForce false;
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    printing.enable = true;

    libinput.enable = true;

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };
}
