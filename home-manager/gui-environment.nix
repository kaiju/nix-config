{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    xorg.xbacklight
    ncpamixer
    xorg.xrdb
    xdg-utils

    # Fonts
    iosevka
    ibm-plex
    font-awesome
    dejavu_fonts
    ubuntu_font_family
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    inconsolata
    cantarell-fonts

    # Apps
    bitwarden
  ];

  programs.rofi = {
    enable = true;
    font = "IBM Plex Mono 10";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    extraConfig = {
      combi-modi = "drun,window,ssh";
    };
  };

  programs.chromium.enable = true;
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles.default = {
      isDefault = true;
      settings = {
        "browser.shell.checkDefaultBrowser" = false;
        "apz.gtk.kinetic_scroll.enabled" = false;
      };
    };
  };

  /*
  programs.i3status-rust = {
    enable = false;
    bars = {
      default = {
        theme = "plain";
        icons = "none";
        blocks = [
          {
            block = "networkmanager";
            on_click = "alacritty -e nmtui";
            ap_format = "{ssid} ({strength})";
            primary_only = true;
          }
          {
            block = "memory";
            display_type = "memory";
            format_mem = "{mem_total_used}";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "temperature";
            scale = "celsius";
          }
          {
            block = "battery";
          }
          {
            block = "backlight";
          }
          {
            block = "sound";
            on_click = "alacritty -e ncpamixer";
          }
          {
            block = "time";
            interval = 60;
            format = "%a %m/%d %I:%M%P";
          }
        ];
      };
    };
  };
  */

  services.gammastep = {
    enable = true;
    latitude = "37.754";
    longitude = "-77.475";
    provider = "manual";
    temperature.night = 2700;
  };

  programs.urxvt = {
    enable = true;
    extraConfig = {
      depth = "32";
      fading = "30";
      internalBorder = "14";
      background = "[90]#1d1f21";
      perl-ext-common = "url-select,clipboard";
      "keysym.C-c" = "perl:clipboard:copy";
      "keysym.C-v" = "perl:clipboard:paste";
    };
    fonts = [
      "xft:Iosevka:size=14"
    ];
    scroll.bar.enable = false;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        "TERM" = "xterm-256color";
      };
      window = {
        opacity = 0.9;
        padding = {
          x = 10;
          y = 10;
        };
      };
      font = {
        size = 11.0;
        normal = {
          family = "Iosevka";
        };
      };
    };
  };

  xresources.path = ".Xdefaults";
  xresources.properties = {
    "*.background" = "#1d1f21";
    "*.foreground" = "#c5c8c6";
    "*.cursorColor" = "#c5c8c6";
    # black
    "*.color0" = "#1d1f21";
    "*.color8" = "#666666";
    # red
    "*.color1" = "#cc6666";
    "*.color9" = "#d54e53";
    # green
    "*.color2" = "#b5bd68";
    "*.color10" = "#b9ca4a";
    # yellow
    "*.color3" = "#f0c674";
    "*.color11" = "#e7c547";
    # blue
    "*.color4" = "#81a2be";
    "*.color12" = "#7aa6da";
    # magenta
    "*.color5" = "#b294bb";
    "*.color13" = "#c397d8";
    # cyan
    "*.color6" = "#8abeb7";
    "*.color14" = "#70c0b1";
    # white
    "*.color7" = "#c5c8c6";
    "*.color15" = "#eaeaea";
  };

}
