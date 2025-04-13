{ config, lib, pkgs, ... }:
let
  ipmiExporterConfig = pkgs.writeTextFile {
    name = "ipmi-exporter-config.yml";
    text = ''
      ---
      modules:
        default:
          collector_cmd:
            bmc: ${pkgs.sudo}/bin/sudo 
            ipmi: ${pkgs.sudo}/bin/sudo 
            chassis: ${pkgs.sudo}/bin/sudo 
            dcmi: ${pkgs.sudo}/bin/sudo 
          custom_args:
            bmc:
              - bmc-info
            ipmi:
              - ipmi-sensors
            chassis:
              - ipmi-chassis
            dcmi:
              - ipmi-dcmi
    '';
  };
in {

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.zfs = {
    autoScrub = {
      enable = true;
    };
    autoSnapshot = {
      enable = true;
    };
  };

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
      user = "root";
      #configFile = ipmiExporterConfig; 
    };
  };

  # allow ipmi-user to run ipmi tools
  security.sudo.extraRules = [
    {
      users = [ "ipmi-exporter" ];
      commands = [
        { command = "${pkgs.freeipmi}/bin/ipmimonitoring"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.freeipmi}/bin/ipmi-sensors"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.freeipmi}/bin/ipmi-dcmi"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.freeipmi}/bin/ipmi-raw"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.freeipmi}/bin/bmc-info"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.freeipmi}/bin/ipmi-chassis"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.freeipmi}/bin/ipmi-sel"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  services.nfs.server = {
    enable = true;
  };
  networking.firewall = {
    allowedTCPPorts = [ 2049 3333 ];
  };
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "tank" ];

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking = {
    useDHCP = false;
    hostName = "straylight";
    hostId = "625f9838";
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

  environment.systemPackages = with pkgs; [
    cloud-hypervisor
    firecracker
    firectl
    btop
    dmidecode
    smartmontools
    virtiofsd
    freeipmi
  ];

}

