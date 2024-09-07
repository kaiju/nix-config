{ config, pkgs, lib, ... }:
{
  programs.dconf.enable = true;

  console.useXkbConfig = true;

  xdg.portal = {
    enable = true;
    config.common.default = "";
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  services.autorandr.enable = true;

  services.displayManager = {
    defaultSession = "default";
  };

  services.libinput = {
    enable = true;
    touchpad = {
      disableWhileTyping = true;
      tapping = false;
    };
  };

  services.xserver = {
    enable = true;
    exportConfiguration = true;

    xkb = {
      options = "ctrl:nocaps";
      layout = "us";
    };

    displayManager = {

      session = [
        {
          manage = "desktop";
          name = "default";
          start = ''exec $HOME/.xsession'';
        }
      ];

      sx = {
        enable = true;
      };

      lightdm = {
        enable = lib.mkDefault false;
        #background = config.mast.wallpaper;
        greeters.mini = {
          enable = true;
          user = "josh";
          extraConfig = ''
            [greeter]
            show-password-label = false
            password-alignment = left
            [greeter-theme]
            font = "Blex Mono Nerd Font"
            background-image = "${config.mast.wallpaper}"
            background-image-size = cover
            window-color = "#1A1B26"
            border-color = "#1A1B26"
            border-width = 0px
            password-border-color = "#1A1B26"
            password-background-color = "#1A1B26"
            password-border-width = 0px
            password-border-radius = 0
          '';
        };
      };

    };

    desktopManager = {
      xterm.enable = true;
    };

  };
}
