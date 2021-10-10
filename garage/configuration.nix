# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.blacklistedKernelModules = [
    "dvb_usb_rtl28xxu"
  ];

  networking.hostName = "garage";

  hardware.bluetooth.enable = true;
  hardware.rtl-sdr.enable = true;

  time.timeZone = "America/NewYork";

  networking.defaultGateway = {
    address = "192.168.8.1";
    interface = "enp2s0";
  };

  networking.useDHCP = false;
  networking.nameservers = [
    "192.168.8.1"
    "1.1.1.1"
    "8.8.8.8"
  ];
  networking.interfaces.enp2s0 = {
    useDHCP = false;
    ipv4.addresses = [ { address = "192.168.8.10"; prefixLength = 21; } ];
  };

  # networking.firewall.allowedTCPPorts = [ 22 80 9100 ];

  services.blueman.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.josh = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    wget
    vim
    git
    usbutils
    rtl_433
    ppp
    htop
    nat-traverse
    exa
    lm_sensors
    bluez
  ];

  systemd.services.rtl_433 = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "RTL_433";
    serviceConfig = {
      Type = "simple";
      User = "root";
      ExecStart = ''${pkgs.rtl_433}/bin/rtl_433 -C si -f 914.906M -Y classic -R 78 -M newmodel -F mqtt:mqtt.mast.haus:1883'';
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.prometheus.exporters = {
    node = {
      enable = true;
      openFirewall = true;
    };
  };

  system.stateVersion = "20.09"; # Did you read the comment?

}

