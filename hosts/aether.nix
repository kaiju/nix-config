{ config, pkgs, ... }:
{
  imports = [
    ../modules/bluetooth.nix
    ../modules/xorg.nix
    ../modules/sdr.nix
    ../modules/containers.nix
    ../modules/audio.nix
  ];

  home-manager.users.josh.imports = [
    ../home-manager/dev-tools.nix
    ../home-manager/obsidian.nix
    ../home-manager/comms.nix
    ../home-manager/sublime-text.nix
    ../home-manager/gui-environment.nix
    ../home-manager/gnupg.nix
    ../home-manager/rbw.nix
    ../home-manager/xorg.nix
  ];

  mast.wallpaper = "${pkgs.mastpkgs.wallpaper}/lenovo-1.jpg";

  # laptop specific i3 status configuration
  home-manager.users.josh.programs.i3status-rust = {
    bars.default.blocks = [
      {
        block = "backlight";
        device = "intel_backlight";
      }
      {
        block = "battery";
        device = "BAT0";
      }
      {
        block = "sound";
        format = " $icon $output_description{ $volume|} ";
      }
      {
        block = "net";
        device = "wlp0s20f3";
        format = " $icon $ssid $ip ";
      }
    ];
  };

  # High DPI settings
  services.xserver = {
    dpi = 210;
    # Set a custom scaled resolution for our display. This seems to solve a bunch of screen tearing issues compared to
    # just running xrandr --output --scale on startup.
    # This modeline was generated by:
    # - Running xrandr --output eDP-1 --scale 1.3x1.3
    # - xrandr --current | grep current to get resolution
    # - cvt <resolution> to generate the appropriate modeline
    extraConfig = ''
      Section "Monitor"
        Identifier "eDP-1"
        # 3328x1872 59.99 Hz (CVT 6.23M9) hsync: 116.31 kHz; pclk: 532.25 MHz
        Modeline "3328x1872_60.00"  532.25  3328 3592 3952 4576  1872 1875 1880 1939 -hsync +vsync
        Option "PreferredMode" "3328x1872_60.00"
      EndSection
    '';
  };
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_AUTO_SCREEN_SET_FACTOR = "0";
    QT_SCALE_FACTOR = "2";
    QT_FONT_DPI = "96";
  };

  home-manager.users.josh.xresources.properties = {
    "Xft.dpi" = "210";
    "*.dpi" = "210";
  };

  home-manager.users.josh.home.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 64;
    x11.enable = true;
  };

  home-manager.users.josh.programs.alacritty.settings.env = {
    "WINIT_X11_SCALE_FACTOR" = "2.3";
  };

  # end

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
  };

  services = {
    fwupd.enable = true; # firmware updater
    fprintd.enable = true; # fingerprint reader
    printing.enable = true;
  };

  environment.systemPackages = with pkgs; [
    _86Box
    usbutils
    xorg.xdpyinfo
    qt5.qtwayland # :(
  ];

}
