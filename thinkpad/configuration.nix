# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/x1/7th-gen>
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  powerManagement.enable = true;

  networking.hostName = "aether";
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  hardware.brillo.enable = true;
  hardware.bluetooth.enable = true;

  time.timeZone = "America/New_York";

  nixpkgs.config.allowUnfree = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = false;
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.windowManager.i3.enable = true;
  #services.xserver.xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;
  #services.xserver.libinput.touchpad.tapping = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "users" "wheel" "networkmanager" "docker" "video" ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  #   firefox
  # ];
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    firefox
    chromium
    git
    gnupg
    lm_sensors
    brillo
    file
    usbutils 
  ];

  programs.vim.defaultEditor = true;
  programs.zsh.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      alacritty
      dmenu 
      imv
      swaybg
      wofi
    ];
  };

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.fwupd.enable = true;
  services.fprintd.enable = true;

  services.blueman.enable = true;

  system.stateVersion = "21.05"; # Did you read the comment?

}

