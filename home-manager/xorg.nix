{ config, pkgs, lib, ... }:
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
      ${pkgs.feh}/bin/feh --bg-fill ${pkgs.wallpaper}/jr-korpa-YXQew2KZjzY-unsplash.jpg
    '';

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        bars = [
          {
            fonts = {
              names = [ "IBM Plex Mono" ];
              size = 10.0;
            };
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
            position = "top";
            colors = {
              background = "#1d1f21";
              separator = "#1d1f21";
              focusedWorkspace = {
                background = "#373b41";
                border = "#373b41";
                text = "#6b7443";
              };
              activeWorkspace = {
                background = "#202729";
                border = "#202729";
                text = "#99ccc9";
              };
              urgentWorkspace = {
                background = "#6e2926";
                border = "#6e2926";
                text = "#ffffff";
              };
              inactiveWorkspace = {
                background = "#161613";
                border = "#161613";
                text = "#75756e";
              };
            };
          }
        ];

        colors.background = "#1d1f21";
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
      enable = true;
      vSync = true;
      shadow = true;
      # Not sure why this is throwing syntax error when giving negative signed ints
      #shadowOffsets = [ -10 -10 ];
      shadowOpacity = 1.0;
      experimentalBackends = true;
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
        icons = "none";
        settings = {
          theme.name = "plain";
          theme.overrides = {
            separator = "";
            idle_bg = "#1d1f21";
            good_bg = "#1d1f21";
            info_bg = "#1d1f21";
          };
        };
        blocks = [
          {
            block = "memory";
            icons_format = "ram ";
            display_type = "memory";
            format_mem = "{mem_used_percents}";
          }
          {
            block = "load";
            icons_format = "load ";
            format = "{1m} {5m} {15m}";
          }
          {
            block = "cpu";
            icons_format = "cpu ";
            interval = 1;
          }
          {
            block = "time";
            icons_format = "  ";
            interval = 60;
            format = "%a %m/%d %I:%M%P";
          }
        ];
      };
    };
  };

}
