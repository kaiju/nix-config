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

  # x220 wallpaper
  #services.xserver.displayManager.lightdm.background = "${pkgs.mastpkgs.wallpaper}/thinkpad_x220.png";
  #home-manager.users.josh.xsession

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
        device = "wlp3s0";
        format = " $icon $ssid $ip ";
      }
    ];
  };

  networking = {
    networkmanager.enable = true;
  };

  hardware.brillo.enable = true; # brightness controls

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
