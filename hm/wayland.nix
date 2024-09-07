{ config, pkgs, lib, ... }:

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

  home.packages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    imv
    swaybg
  ];

  # electron apps
  home.file."sway-session" = {
    enable = true;
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/sh
      export MOZ_ENABLE_WAYLAND=1
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
      export QT_QPA_PLATFORM=wayland
      export GDK_BACKEND=wayland
      export ELECTRON_OZONE_PLATFORM_HINT=wayland

      exec sway
    '';
  };

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
      prompt-text = "> ";
      text-cursor-style = "underscore";
    };
  };

  wayland.windowManager.sway = {
    enable = true;
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
      fonts = {
        names = [ "CommitMonoNerdFont" ];
        style = "Regular";
        size = 10.0;
      };
      modifier = "Mod4";
      menu = "${pkgs.tofi}/bin/tofi-drun";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      gaps = {
        smartBorders = "on";
        smartGaps = true;
        inner = 7;
      };
      startup = [
        { command = "${pkgs.swayidle}/bin/swayidle -w timeout 300 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"'"; }
      ];

      bars = [];

      keybindings = lib.mkOptionDefault {
        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '-5%'";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '+5%'";
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86MonBrightnessUp" = "exec ${pkgs.brillo}/bin/brillo -A 5";
        "XF86MonBrightnessDown" = "exec ${pkgs.brillo}/bin/brillo -U 5";
      };
      
      input = {
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_options = "ctrl:nocaps";
        };
      };

      output = {
        eDP-1 = {
          scale = "1.6";
        };
      };
    };

    extraConfig = ''
      for_window [class="^.*"] inhibit_idle fullscreen
      for_window [app_id="^.*"] inhibit_idle fullscreen

      for_window [app_id="scratch-terminal"] floating enable, resize set height 25 ppt, border none 

      bindsym Mod4+Shift+Return exec ${pkgs.alacritty}/bin/alacritty -o 'window.opacity=0.9' --class "scratch-terminal"
    '';

  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      window.eDP-1 {
        font-size: 11pt;
      }
      window.eDP-1 * {
        border: none;
        font-family: CommitMonoNerdFont;
        border-radius: 0;
        min-height: 0;
        color: #ccc;
      }
      window#waybar {
        background: #16191C;
        color: #AAB2BF;
      }
      #workspaces button {
        padding: 3px 5px;
        margin: 0px;
      }
      #workspaces button.focused {
        background-color: #333;
        color: #fff;
      }
      #clock {
        padding: 3px 5px;
        margin: 0px 4px;
        color: #ffffff;
        background-color: #333;
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
        padding: 3px 4px;
        margin: 0px 4px;
        color: #ffffff;
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
          "network"
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
          format-ethernet = "[ {ipaddr} ]";
          format-wifi = "[ {essid} {ipaddr} ]"; 
        };
        "load" = {
          format = "[ {load1} ]";
        };
        "memory" = {
          format = "[ mem {percentage}% ]";
        };
        "temperature" = {
          thermal-zone = 6;
          format = "[ {temperatureC}°C ]";
        };
        "battery" = {
          format = "[ bat {capacity}% ]";
        };
        "pulseaudio" = {
          format = "[ audio {volume}% ]";
          format-bluetooth = "[ bt {volume}% ]";
          format-muted = "[ muted ]";
        };
        "clock" = {
          format = "{:%I:%M%p}";
        };
      }
    ];
  };

  # notification daemon for Wayland
  services.mako = {
    enable = true;
    font = "CommitMonoNerdFont";
    backgroundColor = "#000000CC";
    borderSize = 0;
    defaultTimeout = 5000;
    margin = "0";
    padding = "10";
  };

  services.wlsunset = {
    enable = true;
    latitude = "37.754";
    longitude = "-77.475";
    temperature.night = 2700;
  };

}
