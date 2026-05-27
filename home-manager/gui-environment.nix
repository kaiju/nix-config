{
  pkgs,
  config,
  ...
}:

{

  home.packages = with pkgs; [
    xbacklight
    ncpamixer
    xrdb
    xdg-utils
    screenfetch

    # Fonts
    iosevka
    ibm-plex
    font-awesome
    dejavu_fonts
    ubuntu-classic
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    inconsolata
    cantarell-fonts

    nerd-fonts.commit-mono
    nerd-fonts.blex-mono
    nerd-fonts.iosevka
    commit-mono

    # Apps
    vlc
    gedit
    dconf-editor
    nemo # file manager
    seahorse # keyring interface
  ];

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
    colorScheme = "dark";
    gtk4.theme = null;
    gtk3.theme = null;
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  xdg = {

    portal = {
      enable = true;
      config.common.default = [
        "gtk"
        "luminous"
      ];
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-luminous
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

  programs.chromium.enable = true;

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles.default = {
      isDefault = true;
      settings = {
        "browser.ml.enable" = false;
        "browser.compactmode.show" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "apz.gtk.kinetic_scroll.enabled" = false;
        "security.ask_for_password" = 0;
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

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      #youtube-upnext
      youtube-chat
      uosc
      quality-menu
    ];
    config = {
      osd-font = "CommitMono Nerd Font";
      osd-font-size = 16;
    };
  };

}
