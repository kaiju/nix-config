{ config, pkgs, lib, ... }:
{
  imports = [
    ../modules/bluetooth.nix
    ../modules/xorg.nix
    ../modules/sdr.nix
    ../modules/containers.nix
    ../modules/audio.nix
  ];

  home-manager.users.josh.imports = [
    ../../hm/dev-tools.nix
    ../../hm/obsidian.nix
    ../../hm/comms.nix
    ../../hm/sublime-text.nix
    ../../hm/gui-environment.nix
    ../../hm/gnupg.nix
    ../../hm/rbw.nix
    ../../hm/xorg.nix
  ];

  mast.wallpaper = "${pkgs.mastpkgs.wallpaper}/thinkpad_x220.png";

  # setup sxrc?
  services.xserver.displayManager.sx.enable = true;
  #services.xserver.displayManager.startx.enable = true;
  #programs.regreet.enable = false;

  services.xserver.displayManager.lightdm.enable = true;

  services.greetd = {
    enable = false;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet -t -r -s ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions";
      #command = "${pkgs.greetd.tuigreet}/bin/tuigreet -t -r -s ${config.services.xserver.displayManager.sessionData.desktops} --cmd ${pkgs.zsh}/bin/zsh";
    };
  };

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
