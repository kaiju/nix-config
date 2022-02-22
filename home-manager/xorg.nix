{ config, pkgs, lib, ... }:
{
  xsession = {
    enable = true;
    initExtra = ''
      setxkbmap -option 'ctrl:nocaps'
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
              background = "#06060f";
              activeWorkspace = {
                background = "#06060f";
                border = "#06060f";
                text = "#61b9c6";
              };
              focusedWorkspace = {
                background = "#06060f";
                border = "#06060f";
                text = "#61b9c6";
              };
              inactiveWorkspace = {
                background = "#06060f";
                border = "#06060f";
                text = "#cccccc";
              };
            };
          }
        ];
        colors.focused = {
          background = "#8c9440";
          indicator = "#b5bd68";
          text = "#ffffff";
          border = "#b5bd68";
          childBorder = "#8c9440";
        };
        defaultWorkspace = "workspace number 1";
        modifier = "Mod4";

        menu = "${pkgs.rofi}/bin/rofi -show combi";

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
    };
  };

  services.polybar = {
    enable = true;
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
          };
        };
        blocks = [
          {
            block = "memory";
            display_type = "memory";
            format_mem = "{mem_total_used}";
          }
          {
            block = "load";
            format = "{1m} {5m} {15m}";
          }
          {
            block = "cpu";
            interval = 1;
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

}
