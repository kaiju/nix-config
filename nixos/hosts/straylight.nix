# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{

  services.prometheus.exporters = {
    zfs = {
      enable = true;
      pools = [ "tank" ];
      openFirewall = true;
    };
    smartctl = {
      enable = true;
      openFirewall = true;
    };
    ipmi = {
      enable = true;
      openFirewall = true;
    };
  };

  services.nfs.server = {
    enable = true;
  };
  networking.firewall = {
    allowedTCPPorts = [ 2049 ];
  };
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "tank" ];

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking = {
    useDHCP = false;
    hostName = "straylight";
    hostId = "625f9838";
    networkmanager.enable = true;
    defaultGateway = {
      address = "192.168.8.1";
      interface = "mast-network";
    };
    nameservers = [
      "192.168.8.1"
    ];
        
    vlans = {
      mast-vlan = {
        id = 10;
        interface = "enp2s0f0";
      };
      iot-vlan = {
        id = 60;
        interface = "enp2s0f0";
      };
    };

    bridges = {
      mast-network = {
        interfaces = ["mast-vlan"];
      };
    };

    interfaces = {
      mast-network = {
        useDHCP = false;
        ipv4.addresses = [
          { address = "192.168.8.3"; prefixLength = 22; }
        ];
      };
    };

  };

  users.users.josh.extraGroups = [ "libvirtd" ];
  home-manager.users.josh.home.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";

  # libvirt
  security.polkit.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "mast-network" "iot-network" ];
    qemu = {
      package = pkgs.qemu_kvm;
      #runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };
  # Prevent default libvirt network from getting created and autostarted
  # https://github.com/NixOS/nixpkgs/issues/73418#issuecomment-883701022
  systemd.services.libvirtd-config.script = lib.mkAfter ''
    rm /var/lib/libvirt/qemu/networks/default.xml
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    virtiofsd
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

}

