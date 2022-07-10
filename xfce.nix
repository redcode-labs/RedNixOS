{
  config,
  pkgs,
  ...
}: {
  services = {
    xserver = {
      desktopManager = {
        xfce.enable = true;
      };
      displayManager = {
        defaultSession = "xfce";
        autoLogin = {
          enable = true;
          user = "red";
        };
      };
    };
  };
}
