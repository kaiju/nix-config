{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    bemenu
    imv
    swaybg
  ];

  # electron apps
  home.file.".config/electron-flags.conf".text = ''
--enable-features=UseOzonePlatform
--ozone-platform=wayland
'';

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    QT_QPA_PLATFORM = "wayland"; # qt5.qtwayland in systemPackages
    GDK_BACKEND = "wayland";
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      colors.focused = {
        background = "#8c9440";
        indicator = "#b5bd68";
        text = "#ffffff";
        border = "#b5bd68";
        childBorder = "#8c9440";
      };
      modifier = "Mod4";
      menu = "${pkgs.rofi}/bin/rofi -show combi";
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
        "*" = {
          bg = "~/Pictures/FBupE08UYAIEavH.jpg fill";
        };
        eDP-1 = {
          scale = "1.5";
        };
      };
    };
    extraConfig = ''
      for_window [class="^.*"] inhibit_idle fullscreen
      for_window [app_id="^.*"] inhibit_idle fullscreen
      bar { swaybar_command waybar }
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
        font-family: IBM Plex Mono;
        border-radius: 0;
        min-height: 0;
        color: #ccc;
      }
      window#waybar {
        background: #16191C;
        color: #AAB2BF;
      }
      #workspaces button {
        padding: 2px 5px;
        margin: 0px;
      }
      #workspaces button.focused {
        background-color: #333;
        color: #fff;
      }
      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #mpd {
        padding: 0 10px;
        margin: 0 4px;
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
          #"wlr/taskbar"
        ];
        modules-right = [
          "tray"
          "network"
          "memory"
          "temperature"
          "battery"
          "pulseaudio"
          "clock"
        ];
        modules = {
          "sway/workspaces" = {
            format = "{name}";
          };
          "network" = {
            format-ethernet = "ip {ipaddr}";
            format-wifi = "ip {ipaddr} network {essid} signal {signalStrength}%";
          };
          "memory" = {
            format = "mem {used:0.1f}G";
          };
          "temperature" = {
            thermal-zone = 6;
            format = "temp {temperatureC}°C";
          };
          "battery" = {
            format = "battery {capacity}%";
          };
          "pulseaudio" = {
            format = "audio {volume}%";
            format-bluetooth = "bluetooth {volume}%";
            format-muted = "muted";
          };
          "clock" = {
            format = "{:%I:%M%p}";
          };
        };
      }
    ];
  };

  # notification daemon for Wayland
  programs.mako = {
    enable = true;
    font = "Iosevka 12";
    backgroundColor = "#333333CC";
    borderSize = 0;
    defaultTimeout = 5000;
  };

}
