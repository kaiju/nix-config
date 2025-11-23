{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
{

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [
        "ctrl:nocaps"
      ];
    };
  };

  home.packages = with pkgs; [
    feh
  ];

  xsession = {
    enable = true;
    initExtra = ''
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option 'ctrl:nocaps'
      ${pkgs.feh}/bin/feh --bg-fill ${osConfig.mast.wallpaper}
    '';

    windowManager.i3 = {
      enable = true;
      config = {

        bars = [
          {
            fonts = {
              names = [ "BlexMono Nerd Font" ];
              size = 10.0;
            };
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
            position = "top";
            colors = {
              background = "#1a1b26";
              separator = "#1a1b26";
              focusedWorkspace = {
                background = "#445441";
                border = "#445441";
                text = "#acb0d0";
              };
              activeWorkspace = {
                background = "#1a1b26";
                border = "#1a1b26";
                text = "#787c99";
              };
              urgentWorkspace = {
                background = "#1a1b26";
                border = "#1a1b26";
                text = "#ff7a93";
              };
              inactiveWorkspace = {
                background = "#1a1b26";
                border = "#1a1b26";
                text = "#a9b1d6";
              };
            };
          }
        ];

        # todo -- fix these
        colors.background = "#1e1e20";
        colors.focused = {
          border = "#707880";
          background = "#1d1f21";
          text = "#707880";
          indicator = "#8c9440";
          childBorder = "#8c9440";
        };
        colors.unfocused = {
          border = "#707880";
          background = "#1d1f21";
          text = "#707880";
          indicator = "#5f819d";
          childBorder = "#5f819d";
        };
        colors.focusedInactive = {
          border = "#707880";
          background = "#1d1f21";
          text = "#707880";
          indicator = "#5f819d";
          childBorder = "#5f819d";
        };
        colors.urgent = {
          border = "#707880";
          background = "#1d1f21";
          text = "#707880";
          indicator = "#5f819d";
          childBorder = "#5f819d";
        };
        colors.placeholder = {
          border = "#707880";
          background = "#1d1f21";
          text = "#707880";
          indicator = "#5f819d";
          childBorder = "#5f819d";
        };

        defaultWorkspace = "workspace number 1";
        modifier = "Mod4";

        menu = "${pkgs.rofi}/bin/rofi -dpi -show combi";

        terminal = "${pkgs.alacritty}/bin/alacritty";

        gaps = {
          smartBorders = "off";
          smartGaps = false;
          inner = 7;
        };

        window = {
          border = 1;
        };

        keybindings = lib.mkOptionDefault {
          "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '-5%'";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '+5%'";
          "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86MonBrightnessUp" = "exec ${pkgs.brillo}/bin/brillo -A 5";
          "XF86MonBrightnessDown" = "exec ${pkgs.brillo}/bin/brillo -U 5";
        };
      };
    };
  };

  services = {
    picom = {
      enable = false;
      vSync = true;
      shadow = true;
      # Not sure why this is throwing syntax error when giving negative signed ints
      #shadowOffsets = [ -10 -10 ];
      shadowOpacity = 1.0;
      shadowExclude = [
        "window_type *= 'menu'"
        "name ~= 'Firefox$'"
      ];
    };
    flameshot = {
      enable = true;
      settings = {
        General = {
          showHelp = false;
          savePath = "/home/josh";
        };
      };
    };
  };

  services.polybar = {
    enable = false;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
    };
    script = "polybar -r top &";
    settings = {
      "bar/top" = {
        bottom = false;
        width = "100%";
        locale = "en_US.UTF-8";
        font = [
          "IBM Plex Mono:size=10"
        ];
        modules-left = "i3";
        modules-right = "date";
      };
      "module/i3" = {
        type = "internal/i3";
      };
      "module/date" = {
        type = "internal/date";
        interval = 1.0;
        label = "%date% %time%";
        date = "%Y/%m/%d%";
        time = "%I:%M%P";
      };
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        icons = "material-nf";
        settings = {
          theme.theme = "plain";
          theme.overrides = {
            separator = "";
            idle_bg = "#1a1b26";
            idle_fg = "#a9b1d6";
            good_bg = "#1a1b26";
            good_fg = "#9ece6a";
            info_bg = "#1a1b26";
            info_fg = "#787c99";
            critical_bg = "#1a1b26";
            critical_fg = "#ff7a93";
            warning_bg = "#1a1b26";
            warning_fg = "#e0af68";
          };
        };
        blocks = [
          {
            block = "load";
          }
          {
            block = "cpu";
            interval = 1;
            format = " $icon $utilization ";
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents ";
          }
          {
            block = "time";
            interval = 60;
            format = " $timestamp.datetime(f:'%a %m/%d %I:%M%P')";
          }
        ];
      };
    };
  };

}
