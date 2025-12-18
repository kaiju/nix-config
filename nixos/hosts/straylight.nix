{
  lib,
  pkgs,
  ...
}:
{

  imports = [
    ../modules/server.nix
    ../users/josh.nix
  ];

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
      group = "root";
    };
  };

  systemd.services = {
    "prometheus-ipmi-exporter" = {
      serviceConfig = {
        # allow root to use ipmi tools
        PrivateDevices = false;
        DeviceAllow = lib.mkForce true;
      };
    };
  };

  environment.etc."alloy/ipmi.alloy" = {
    text = ''
      prometheus.scrape "ipmi_exporter" {
          targets = [{"__address__" = "127.0.0.1:9290", "instance" = "straylight"}]
          forward_to = [prometheus.remote_write.ops.receiver]
      }
    '';
  };

  environment.etc."alloy/zfs.alloy" = {
    text = ''
      prometheus.scrape "zfs_exporter" {
          targets = [{"__address__" = "127.0.0.1:9134", "instance" = "straylight"}]
          forward_to = [prometheus.remote_write.ops.receiver]
      }
    '';
  };

  environment.etc."alloy/smartctl.alloy" = {
    text = ''
      prometheus.scrape "smartctl_exporter" {
          targets = [{"__address__" = "127.0.0.1:9633", "instance" = "straylight"}]
          forward_to = [prometheus.remote_write.ops.receiver]
      }
    '';
  };

  services.nfs.server = {
    enable = true;
  };
  networking.firewall = {
    allowedTCPPorts = [
      2049
      3333
    ];
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
        interfaces = [ "mast-vlan" ];
      };
    };

    interfaces = {
      mast-network = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.8.3";
            prefixLength = 22;
          }
        ];
      };
    };

  };

  users.users.josh.extraGroups = [
    "libvirtd"
    "incus-admin"
  ];
  home-manager.users.josh.home.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";

  # libvirt
  security.polkit.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [
      "mast-network"
      "iot-network"
    ];
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };

  # Prevent default libvirt network from getting created and autostarted
  # https://github.com/NixOS/nixpkgs/issues/73418#issuecomment-883701022
  systemd.services.libvirtd-config.script = lib.mkAfter ''
    rm /var/lib/libvirt/qemu/networks/default.xml
  '';

  # hey why not
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };

  environment.systemPackages = with pkgs; [
    btop
    dmidecode
    smartmontools
    virtiofsd
    freeipmi
  ];

}
