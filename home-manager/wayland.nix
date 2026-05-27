{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

{

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
      colors-dark = {
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

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    extraSessionCommands = ''
      #export WLR_SCENE_DISABLED_DIRECT_SCANOUT=1
      #export WLR_RENDER_NO_EXPLICIT_SYNC=1
      export MOZ_ENABLE_WAYLAND=1
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
      export QT_QPA_PLATFORM=wayland
      export GDK_BACKEND=wayland,x11
      export ELECTRON_OZONE_PLATFORM_HINT=wayland
    '';
    wrapperFeatures.gtk = true;
    config = {
      defaultWorkspace = "workspace number 1";
      fonts = {
        names = [ "CommitMonoNerdFont" ];
        style = "Regular";
        size = 10.0;
      };
      colors = {
        background = "#ffffff";
        focused = {
          background = "#${osConfig.mast.colors.black}";
          border = "#${osConfig.mast.colors.black}";
          childBorder = "#${osConfig.mast.colors.black}";
          indicator = "#${osConfig.mast.colors.black}";
          text = "#${osConfig.mast.colors.foreground}";
        };
        focusedInactive = {
          background = "#${osConfig.mast.colors.background}";
          border = "#${osConfig.mast.colors.background}";
          childBorder = "#${osConfig.mast.colors.background}";
          indicator = "#${osConfig.mast.colors.background}";
          text = "#${osConfig.mast.colors.white}";
        };
        unfocused = {
          background = "#${osConfig.mast.colors.background}";
          border = "#${osConfig.mast.colors.background}";
          childBorder = "#${osConfig.mast.colors.background}";
          indicator = "#${osConfig.mast.colors.background}";
          text = "#${osConfig.mast.colors.white}";
        };
        urgent = {
          background = "#${osConfig.mast.colors.background}";
          border = "#${osConfig.mast.colors.background}";
          childBorder = "#${osConfig.mast.colors.background}";
          indicator = "#${osConfig.mast.colors.background}";
          text = "#${osConfig.mast.colors.white}";
        };
      };
      modifier = "Mod4";
      menu = "${pkgs.tofi}/bin/tofi-drun";
      terminal = "${pkgs.foot}/bin/foot";
      gaps = {
        smartBorders = "on";
        smartGaps = true;
        inner = 7;
      };

      bars = [ ];

      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '-5%'";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '+5%'";
          "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86MonBrightnessUp" = "exec ${pkgs.brillo}/bin/brillo -A 5";
          "XF86MonBrightnessDown" = "exec ${pkgs.brillo}/bin/brillo -U 5";
          "${modifier}+Shift+Return" = "exec ${pkgs.foot}/bin/foot -a float-terminal";
        };

      input = {
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
      for_window [app_id="float-terminal"] floating enable, resize set 50 ppt 50 ppt, move absolute position center
    '';

  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      window * {
        border: none;
        font-family: CommitMonoNerdFont;
        border-radius: 0;
        min-height: 0;
      }
      window#waybar {
        font-size: 10pt;
        background: #${osConfig.mast.colors.background};
        color: #${osConfig.mast.colors.foreground};
      }
      label.module {
        margin: 0px;
        padding: 5px 15px;
      }
      #workspaces button {
        padding: 5px 5px;
      }
      #workspaces button.focused {
        padding: 5px 10px;
        background-color: #${osConfig.mast.colors.black};
        color: #d0d0d0;
      }
      box#tray {
        padding: 5px 15px;
      }
      #clock {
        color: #d0d0d0;
        background-color: #${osConfig.mast.colors.black};
      }
      #tray {
        color: #fff;
      }
      #mode {
        background-color: #${osConfig.mast.colors.black};
        color: #ffffff;
      }
      #window {
        padding: 5px 10px;
        background-image: linear-gradient(to right, #${osConfig.mast.colors.black}, #${osConfig.mast.colors.background});
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
      #idle_inhibitor,
      #mpd {
        color: #${osConfig.mast.colors.white};
        border-style: solid;
        border-width: 0px 0px 0px 1px;
        border-color: #${osConfig.mast.colors.black};
      }
    '';
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [
          "sway/workspaces"
          "sway/window"
          "sway/mode"
        ];
        modules-right = [
          "tray"
          #"network"
          "load"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "pulseaudio"
          "clock"
        ];
        "sway/workspaces" = {
          format = "{name}";
        };
        "sway/window" = {
          format = "> {title}";
        };
        "network" = {
          format-ethernet = "{ipaddr}";
          format-wifi = "{essid} {ipaddr}";
        };
        "load" = {
          format = " {load1:5}";
        };
        "cpu" = {
          format = " {usage:3}%";
        };
        "memory" = {
          format = " {percentage:3}%";
        };
        "temperature" = {
          thermal-zone = 6;
          format = " {temperatureC}°C";
        };
        "battery" = {
          format = "{icon} {capacity:3}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "pulseaudio" = {
          format = "  {volume:3}%";
          format-bluetooth = " {volume:3}%";
          format-muted = "  MUTE";
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
