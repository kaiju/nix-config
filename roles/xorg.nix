{ config, pkgs, ... }:
{
  programs.dconf.enable = true;

  console.useXkbConfig = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  services.autorandr.enable = true;
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
      lightdm.background = "${pkgs.wallpaper}/jr-korpa-YXQew2KZjzY-unsplash.jpg";
      lightdm.greeters.mini = {
        enable = true;
        user = "josh";
      };
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
