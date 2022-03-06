{ config, pkgs, ... }:
let 
  dpi = 168;
in {
  imports = [
    ../roles/base.nix
    ../roles/efi-boot.nix
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
    #../home-manager/wayland.nix
    ../home-manager/xorg.nix
  ];

  powerManagement.enable = true;

  hardware.opengl.enable = true;

  # DPI settings
  hardware.video.hidpi.enable = true;
  services.xserver.dpi = dpi;
  environment.variables = {
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "0.9";
    #QT_SCALE_FACTOR = "2";
    #_JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
  services.xserver.displayManager.sessionCommands = ''
    setxkbmap -option 'caps:ctrl_modifier'
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
    Xft.dpi: ${builtins.toString dpi} 
    *.dpi: ${builtins.toString dpi} 
    EOF
  '';

  programs.dconf.enable = true;

  home-manager.users.josh.gtk.enable = true;
  home-manager.users.josh.gtk.font.name = "Cantarell";
  home-manager.users.josh.gtk.font.size = 10;
  home-manager.users.josh.qt.enable = true;
  home-manager.users.josh.qt.platformTheme = "gtk";

  networking = {
    hostName = "aether";
    useDHCP = false;
    networkmanager.enable = true;
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
  };

  hardware = {
    brillo.enable = true; # brightness controls
  };

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

  security.rtkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    gtkUsePortal = true;
  };

  environment.systemPackages = with pkgs; [
    pulseaudio
    usbutils
    qt5.qtwayland # :(
  ];

  system.stateVersion = "21.05";

}
