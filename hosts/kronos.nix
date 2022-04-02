{ config, pkgs, ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/server.nix
  ];
  
  # ZFS configuration
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "tank" ];
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
  '';
  services.zfs.autoScrub.enable = true;

  # Networking
  networking = {
    hostName = "kronos";
    hostId = "00dddef1";
    useDHCP = false;
    defaultGateway = "192.168.8.1";
    nameservers = [ "192.168.8.1" ];

    interfaces.internal0 = {
      virtual = true
      virtualOwner = "root";
      virtualType = "tap";
    };

    interfaces.internalbr0 = {
      ipv4.addresses = [ { address = "10.10.10.1"; prefixLength = 24; }];
    };

    interfaces.br0 = {
      ipv4.addresses = [ { address = "192.168.8.11"; prefixLength = 22; }];
    };

    interfaces.bridges = {
      internalbr0.interfaces = [ "internal0" ];
      br0.interfaces = [ "enp1s0f0" ];
    };

  };

  # Libvirt
  virtualisation.libvirtd = { 
    enable = true;
    allowedBridges = [ "internalbr0" "br0" ];
    qemu.ovmf.enable = true;
    package = pkgs.libvirt.override { enableIscsi = true; }
  };

  system.stateVersion = "21.11";

  # me
  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
  };

}
