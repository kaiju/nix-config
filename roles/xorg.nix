{ config, pkgs, ... }:
{
  console.useXkbConfig = true;
  services.xserver = {
    enable = true;

    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        tapping = false;
      };
    };

    layout = "us";
    xkbOptions = "ctrl:nocaps";

    displayManager = {
      lightdm.enable = true;
      defaultSession = "xsession";
      session = [
        {
          manage = "desktop";
          name = "xsession";
          start = ''exec $HOME/.xsession'';
        }
      ];
    };

    desktopManager = {
      xterm.enable = true;
    };

  };
}
