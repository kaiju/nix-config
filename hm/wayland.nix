{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

{

  # not here in future
  /*
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["IBM Plex Mono"];
        sansSerif = ["DejaVu Sans"];
        serif = ["DejaVu Serif"];
      };
    };
  */

  programs.chromium.commandLineArgs = [
    "--ozone-platform-hint=auto"
  ];

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "CommitMonoNerdFont:size=10";
        term = "xterm-256color";
        pad = "5x5";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      colors = {
        alpha = "1.0";
        background = osConfig.mast.colors.background;
        foreground = osConfig.mast.colors.foreground;
        regular0 = osConfig.mast.colors.black;
        regular1 = osConfig.mast.colors.red;
        regular2 = osConfig.mast.colors.green;
        regular3 = osConfig.mast.colors.yellow;
        regular4 = osConfig.mast.colors.blue;
        regular5 = osConfig.mast.colors.magenta;
        regular6 = osConfig.mast.colors.cyan;
        regular7 = osConfig.mast.colors.white;
        bright0 = osConfig.mast.colors.brightBlack;
        bright1 = osConfig.mast.colors.brightRed;
        bright2 = osConfig.mast.colors.brightGreen;
        bright3 = osConfig.mast.colors.brightYellow;
        bright4 = osConfig.mast.colors.brightBlue;
        bright5 = osConfig.mast.colors.brightMagenta;
        bright6 = osConfig.mast.colors.brightCyan;
        bright7 = osConfig.mast.colors.brightWhite;
      };
    };
  };

  home.packages = with pkgs; [
    swaylock
    wl-clipboard
    imv
    swaybg
  ];

  programs.tofi = {
    enable = true;
    settings = {
      drun-launch = true;
      anchor = "top-left";
      width = "25%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      padding-left = "2%";
      padding-top = "2%";
      padding-right = "2%";
      padding-bottom = "2%";
      result-spacing = 3;
      num-results = 0;
      font = "CommitMono";
      font-size = 12;
      background-color = "#000C";
      text-color = "#${osConfig.mast.colors.foreground}";
      selection-color = "#${osConfig.mast.colors.yellow}";
      prompt-text = "> ";
      text-cursor-style = "underscore";
    };
  };

  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        path = osConfig.mast.wallpaper;
      };
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.sway}/bin/swaymsg \"output * dpms off\"";
        resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";
      }
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {

      "$terminal" = "${pkgs.foot}/bin/foot";
      "$menu" = "${pkgs.tofi}/bin/tofi-drun";

      input = {
        "kb_layout" = "us";
        "kb_options" = "ctrl:nocaps";
        "follow_mouse" = "1";
        touchpad = {
          "natural_scroll" = "false";
          "disable_while_typing" = "true";
          "tap-to-click" = "false";
        };

      };

      animations = {
        enabled = false;
      };

      "$mod" = "SUPER";

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, D, exec, $menu"

        "$mod SHIFT, Q, killactive,"
        "$mod, F, fullscreen,"

        "$mod, R, resizeactive,"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

      ];

      env = [
        "GDK_BACKEND,wayland"
        "QT_QPA_PLATFORM,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "GDK_BACKEND,wayland"
      ];

    };
  };

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
      export QT_QPA_PLATFORM=wayland
      export GDK_BACKEND=wayland
      export ELECTRON_OZONE_PLATFORM_HINT=wayland
    '';
    wrapperFeatures.gtk = true;
    config = {
      defaultWorkspace = "1";
      fonts = {
        names = [ "CommitMonoNerdFont" ];
        style = "Regular";
        size = 10.0;
      };
      colors = {
        background = "#ffffff";
        focused = {
          #background = "#285577";
          #border = "#4c7899";
          #childBorder = "#285577";
          #indicator = "#2e9ef4";
          #text = "#ffffff";
          background = "#${osConfig.mast.colors.black}";
          border = "#${osConfig.mast.colors.black}";
          childBorder = "#${osConfig.mast.colors.black}";
          indicator = "#${osConfig.mast.colors.black}";
          text = "#${osConfig.mast.colors.foreground}";
        };
        focusedInactive = {
          #background = "#222222";
          #border = "#333333";
          #childBorder = "#222222";
          #indicator = "#292d2e";
          #text = "#888888";
          background = "#${osConfig.mast.colors.background}";
          border = "#${osConfig.mast.colors.background}";
          childBorder = "#${osConfig.mast.colors.background}";
          indicator = "#${osConfig.mast.colors.background}";
          text = "#${osConfig.mast.colors.white}";
        };
        unfocused = {
          #background = "#222222";
          #border = "#333333";
          #childBorder = "#222222";
          #indicator = "#292d2e";
          #text = "#888888";
          background = "#${osConfig.mast.colors.background}";
          border = "#${osConfig.mast.colors.background}";
          childBorder = "#${osConfig.mast.colors.background}";
          indicator = "#${osConfig.mast.colors.background}";
          text = "#${osConfig.mast.colors.white}";
        };
        urgent = {
          #background = "#900000";
          #border = "#2f343a";
          #childBorder = "#900000";
          #indicator = "#900000";
          #text = "#ffffff";
          background = "#${osConfig.mast.colors.background}";
          border = "#${osConfig.mast.colors.background}";
          childBorder = "#${osConfig.mast.colors.background}";
          indicator = "#${osConfig.mast.colors.background}";
          text = "#${osConfig.mast.colors.white}";
        };
      };
      modifier = "Mod4";
      menu = "${pkgs.tofi}/bin/tofi-drun";
      #terminal = "${pkgs.alacritty}/bin/alacritty";
      terminal = "${pkgs.foot}/bin/foot";
      gaps = {
        smartBorders = "on";
        smartGaps = true;
        inner = 7;
      };

      bars = [ ];

      keybindings = lib.mkOptionDefault {
        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '-5%'";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '+5%'";
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86MonBrightnessUp" = "exec ${pkgs.brillo}/bin/brillo -A 5";
        "XF86MonBrightnessDown" = "exec ${pkgs.brillo}/bin/brillo -U 5";
      };

      input = {
        #"1:1:AT_Translated_Set_2_keyboard" = {
        "type:keyboard" = {
          xkb_options = "ctrl:nocaps";
        };
      };

      startup = [
        {
          command = "${pkgs.foot}/bin/foot -a scratch-terminal";
        }
      ];

    };

    extraConfig = ''
      for_window [class="^.*"] inhibit_idle fullscreen
      for_window [app_id="^.*"] inhibit_idle fullscreen

      for_window [app_id="scratch-terminal"] floating enable, resize set width 75 ppt height 30 ppt, border pixel 5 
    '';

  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      window {
        font-size: 11pt;
      }
      window * {
        border: none;
        font-family: CommitMonoNerdFont;
        border-radius: 0;
        min-height: 0;
        color: #${osConfig.mast.colors.foreground};
      }
      window#waybar {
        background: #${osConfig.mast.colors.background};
        color: #${osConfig.mast.colors.foreground};
      }
      #workspaces button {
        padding: 3px 5px;
        margin: 0px;
      }
      #workspaces button.focused {
        background-color: #${osConfig.mast.colors.black};
        color: #${osConfig.mast.colors.white};
      }
      #clock {
        padding: 3px 5px;
        margin: 0px 4px;
        color: #${osConfig.mast.colors.white};
        background-color: #${osConfig.mast.colors.black};
      }
      #tray {
        padding: 3px 4px;
        margin: 0px 0px;
        color: #fff;
      }
      #tray * {
        margin: 0px 5px;
      }
      #battery,
      #cpu,
      #memory,
      #load,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #custom-media,
      #mode,
      #idle_inhibitor,
      #mpd {
        color: #${osConfig.mast.colors.white};
        padding: 3px 5px;
        margin: 0px 4px;
      }
    '';
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-right = [
          "tray"
          #"network"
          "load"
          "memory"
          "temperature"
          "battery"
          "pulseaudio"
          "clock"
        ];
        "sway/workspaces" = {
          format = "{name}";
        };
        "network" = {
          format-ethernet = "{ipaddr}";
          format-wifi = "{essid} {ipaddr}";
        };
        "load" = {
          format = "[ {load1:4} ]";
        };
        "memory" = {
          format = " {percentage}%";
        };
        "temperature" = {
          thermal-zone = 6;
          format = " {temperatureC}°C";
        };
        "battery" = {
          format = "{icon}  {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "pulseaudio" = {
          format = "  {volume}%";
          format-bluetooth = " {volume}%";
          format-muted = "";
        };
        "clock" = {
          format = "{:%F %I:%M%p}";
        };
      }
    ];
  };

  # notification daemon for Wayland
  services.mako = {
    enable = true;
    settings = {
      defaultTimeout = 5000;
      borderSize = 0;
      font = "CommitMonoNerdFont";
      backgroundColor = "#000000CC";
      margin = "0";
      padding = "10";
    };
  };

  services.wlsunset = {
    enable = true;
    latitude = "37.754";
    longitude = "-77.475";
    temperature.night = 2700;
  };

}
