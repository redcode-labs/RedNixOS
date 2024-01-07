{lib, ...}: {
  boot.plymouth.enable = true;

  hardware = {
    opengl.enable = true;
    # disable pulse since we're using pipewire
    pulseaudio.enable = lib.mkForce false;
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    printing.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";
      libinput.enable = true;
    };
  };
}
