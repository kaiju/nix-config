{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    rofi
    xorg.xbacklight
    ncpamixer

    # Fonts
    iosevka
    font-awesome

    # Apps
    element-desktop
    tdesktop
    obsidian
    virt-manager
    syncthing
    bitwarden
    zoom-us
    sublime4
    chromium

    # wayland
    swaylock
    swayidle
    wl-clipboard
    bemenu
    imv
    swaybg
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
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
      menu = "rofi -show combi";
      terminal = "alacritty";
      gaps = {
        smartBorders = "on";
        smartGaps = true;
        inner = 7;
      };
      startup = [
        { command = "${pkgs.swayidle}/bin/swayidle -w timeout 300 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"'"; }
      ];
      bars = [
        {
          fonts = {
            names = [ "Iosevka" "Font Awesome 5 Free 12" ];
            size = 12.0;
          };
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
        }
      ];
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
          bg = "~/Pictures/awesome_bg_0.png tile";
        };
        eDP-1 = {
          scale = "1.3";
        };
      };
    };
    extraConfig = ''for_window [class="^.*"] inhibit_idle fullscreen
                    for_window [app_id="^.*"] inhibit_idle fullscreen
                  '';
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles.default = {
      isDefault = true;
      settings = {
        "apz.gtk.kinetic_scroll.enabled" = false;
      };
    };
  };

  programs.i3status-rust = {
    enable = true;
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

  services.gammastep = {
    enable = true;
    latitude = "37.754";
    longitude = "-77.475";
    provider = "manual";
    temperature.night = 2700;
  };

  # notification daemon for Wayland
  programs.mako = {
    enable = true;
    font = "Iosevka 12";
    backgroundColor = "#333333CC";
    borderSize = 0;
    defaultTimeout = 5000;
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
      "keysym.C-v" = "perl:clipdboard:paste";
    };
    fonts = [
      "xft:Iosevka:size=12"
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
        padding = {
          x = 10;
          y = 10;
        };
      };
      background_opacity = 0.9;
      font = {
        size = 12.0;
        normal = {
          family = "Iosevka";
        };
      };
    };
  };

  xresources.path = "$HOME/.Xdefaults";
  xresources.properties = {
    "rofi.combi-modi" = "drun,window,ssh";
    "rofi.modi" = "combi";
    "rofi.theme" = "gruvbox-dark";
    "rofi.font" = "Iosevka 12";
    "rofi.terminal" = "alacritty";
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
