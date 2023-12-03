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
  services.xserver = {
    enable = true;
    exportConfiguration = true;

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
      lightdm.enable = lib.mkDefault true;
      lightdm.background = config.mast.wallpaper;
      lightdm.greeters.mini = {
        enable = true;
        user = "josh";
        extraConfig = ''
          [greeter]
          show-password-label = false
          password-alignment = left
          [greeter-theme]
          font = "IBM Plex Mono"
          window-color = "#1A1B26"
          border-color = "#1A1B26"
          border-width = 0px
          password-border-color = "#1A1B26"
          password-background-color = "#1A1B26"
          password-border-width = 0px
          password-border-radius = 0
        '';
      };
      defaultSession = "default";
      session = [
        {
          manage = "desktop";
          name = "default";
          start = ''exec $HOME/.xsession'';
        }
      ];
    };

    desktopManager = {
      xterm.enable = true;
    };

  };
}
