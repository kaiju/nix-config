{ config, pkgs, lib, osConfig, ... }:

{

  home.packages = with pkgs; [
    xorg.xbacklight
    ncpamixer
    xorg.xrdb
    xdg-utils
    screenfetch

    # Fonts
    iosevka
    ibm-plex
    font-awesome
    dejavu_fonts
    ubuntu_font_family
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    inconsolata
    cantarell-fonts

    #nerdfonts
    nerd-fonts.commit-mono
    nerd-fonts.blex-mono
    nerd-fonts.iosevka
    commit-mono

    # Apps
    bitwarden
    vlc
  ];

  #services.gnome-keyring.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "Cantarell";
      size = 10;
    };
    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    /*
    gtk2.extraConfig = ''
    '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    */
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  xdg = {

    portal = {
      enable = true;
      config.common.default = ["gtk" "wlr"];
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };

    mime.enable = true;

    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
      };
      associations.added = {
        "image/jpeg" = "firefox.desktop";
        "image/jpg" = "firefox.desktop";
        "image/gif" = "firefox.desktop";
        "image/png" = "firefox.desktop";
        "image/webp" = "firefox.desktop";
        "application/pdf" = "firefox.desktop";
      };
      associations.removed = {
        "image/jpeg" = "chromium-browser.desktop";
        "image/jpg" = "feh.desktop";
        "image/gif" = "chromium-browser.desktop";
        "image/png" = "chromium-browser.desktop";
        "image/webp" = "chromium-browser.desktop";
        "application/pdf" = "chromium-browser.desktop";
      };
    };

  };

  programs.rofi = {
    enable = true;
    font = "Blex Mono Nerd Font 10";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "Monokai";
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
        "browser.compactmode.show" = true;
        "security.ask_for_password" = 0;
        "dom.battery.enabled" = false;
        "extensions.pocket.enabled" = false;
        "extensions.pocket.showHome" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "apz.gtk.kinetic_scroll.enabled" = false;
        "gfx.webrender.all" = true;
        "media.ffpmeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        "media.rdd-vpx.enabled" = false;
        "gfx.webrender.compositor.force-enabled" = true;
        "media.navigator.mediadatadecoder_vpx_enabled" = true;
        "webgl.force-enabled" = true;
        "layers.acceleration.force-enabled" = true;
        "layers.offmainthreadcomposition.enabled" = true;
        "layers.offmainthreadcomposition.async-animations" = true;
        "html5.offmainthread" = true;
        "signon.rememberSignons" = false;
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
        "WINIT_X11_SCALE_FACTOR" = lib.mkDefault "1";
      };
      window = {
        opacity = 1.0;
        padding = {
          x = 10;
          y = 10;
        };
      };
      font = {
        size = 11.0;
        normal = {
          family = "Iosevka Nerd Font";
        };
      };
      # tokyo night
      colors = {
        primary = {
          foreground = "0xa9b1d6";
          background = "0x1a1b26";
        };
        normal = {
          black = "0x32344a";
          red = "0xf7768e";
          green = "0x9ece6a";
          yellow = "0xe0af68";
          blue = "0x7aa2f7";
          magenta = "0xad8ee6";
          cyan = "0x449dab";
          white = "0x787c99";
        };
        bright = {
          black = "0x444b6a";
          red = "0xff7a93";
          green = "0xb9f27c";
          yellow = "0xff9e64";
          blue = "0x7da6ff";
          magenta = "0xbb9af7";
          cyan = "0x0db9d7";
          white = "0xacb0d0";
        };
      };
    };
  };

  xresources.path = ".Xdefaults";

  xresources.extraConfig = ''
    ! Base16 Yesterday
    ! Scheme: FroZnShiva (https://github.com/FroZnShiva)

    #define base00 #1d1f21
    #define base01 #282a2e
    #define base02 #4d4d4c
    #define base03 #969896
    #define base04 #8e908c
    #define base05 #d6d6d6
    #define base06 #efefef
    #define base07 #ffffff
    #define base08 #c82829
    #define base09 #f5871f
    #define base0A #eab700
    #define base0B #718c00
    #define base0C #3e999f
    #define base0D #4271ae
    #define base0E #8959a8
    #define base0F #7f2a1d

    *foreground:   base05
    *background:   base00
    *cursorColor:  base05

    *color0:       base00
    *color1:       base08
    *color2:       base0B
    *color3:       base0A
    *color4:       base0D
    *color5:       base0E
    *color6:       base0C
    *color7:       base05

    *color8:       base03
    *color9:       base09
    *color10:      base01
    *color11:      base02
    *color12:      base04
    *color13:      base06
    *color14:      base0F
    *color15:      base07
  '';

  /*
  xresources.properties = {
    "*foreground" = "#c5c8c6";
    "*background" = "#1d1f21";
    "*cursorColor" = "#c5c8c6";
    # black
    "*color0" = "#1d1f21";
    "*color8" = "#666666";
    # red
    "*color1" = "#cc6666";
    "*color9" = "#d54e53";
    # green
    "*color2" = "#b5bd68";
    "*color10" = "#b9ca4a";
    # yellow
    "*color3" = "#f0c674";
    "*color11" = "#e7c547";
    # blue
    "*color4" = "#81a2be";
    "*color12" = "#7aa6da";
    # magenta
    "*color5" = "#b294bb";
    "*color13" = "#c397d8";
    # cyan
    "*color6" = "#8abeb7";
    "*color14" = "#70c0b1";
    # white
    "*color7" = "#c5c8c6";
    "*color15" = "#eaeaea";
  };
  */

}
