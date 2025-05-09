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
    ../../hm/wayland.nix
  ];

  mast.wallpaper = "${pkgs.mastpkgs.wallpaper}/thinkpad_x220.png";

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.cage}/bin/cage -s -d -- ${pkgs.foot}/bin/foot ${pkgs.greetd.tuigreet}/bin/tuigreet -t -r -c sway";
    };
  };

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
