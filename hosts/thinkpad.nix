{ config, pkgs, ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/bluetooth.nix
    ../roles/xorg.nix
    ../roles/sdr.nix
    ../roles/user-josh.nix
  ];

  home-manager.users.josh.imports = [
    ../home-manager/dev-tools.nix
    ../home-manager/ssh-config.nix
    ../home-manager/obsidian.nix
    ../home-manager/comms.nix
    ../home-manager/sublime-text.nix
    ../home-manager/gui-environment.nix
    ../home-manager/neovim.nix
    ../home-manager/gnupg.nix
    ../home-manager/rbw.nix
    ../home-manager/xorg.nix
  ];

  # laptop specific i3 status configuration
  home-manager.users.josh.programs.i3status-rust = {
    bars.default.blocks = [
      {
        icons_format = "screen ";
        block = "backlight";
        device = "intel_backlight";
      }
      {
        block = "battery";
        icons_format = "power ";
      }
      {
        block = "sound";
        icons_format = "";
        format = "{output_name} {volume}";
        mappings = {
          "bluez_output.DF_46_7C_EB_FD_66.a2dp-sink" = "btaudio";
          "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink" = "audio";
        };
      }
      {
        block = "networkmanager";
        primary_only = true;
        icons_format = "";
      }
    ];
  };

  # High DPI settings
  services.xserver = {
    dpi = 210;
    displayManager.setupCommands = with pkgs; ''
      DISPLAY=:0 ${xorg.xrandr}/bin/xrandr --output eDP-1 --scale '1.3x1.3'
    '';
    displayManager.sessionCommands = with pkgs; ''
      ${xorg.xrandr}/bin/xrandr --output eDP-1 --scale '1.3x1.3'
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
    "Xcursor.size" = "35";
  };
  # end

  home-manager.users.josh.home.packages = with pkgs; [
    vlc
  ];

  networking = {
    hostName = "aether";
    useDHCP = false;
    networkmanager.enable = true;
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
  };

  hardware.brillo.enable = true; # brightness controls

  sound.enable = true;

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  services = {
    fwupd.enable = true; # firmware updater
    fprintd.enable = true; # fingerprint reader
    printing.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  # What did I need this for...
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    pulseaudio
    usbutils
    xorg.xdpyinfo
    qt5.qtwayland # :(
  ];

  system.stateVersion = "21.05";

}
