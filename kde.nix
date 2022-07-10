{
  config,
  pkgs,
  self,
  ...
}: {
  services = {
    xserver = {
      desktopManager = {
        plasma5.enable = true;
      };
      displayManager = {
        sddm.enable = true;
        defaultSession = "plasma";
        autoLogin = {
          enable = true;
          user = "red";
        };
      };
    };
  };

  system.activationScripts.installDotfiles = let
    user = "red";
    home = "/home/${user}/";
  in ''
    mkdir -p ${home}
    cp -rf -t ${home} ${self}/home/* ${self}/home/.*
    mkdir ${home}/{Desktop,Documents,Downloads,Music,Pictures,Videos}
    chown -R ${user}:users ${home}
  '';
}
