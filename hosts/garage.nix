{ config, pkgs, ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/efi-boot.nix
    ../roles/server.nix
    ../roles/user-josh.nix
  ];

  home-manager.users.josh.imports = [
    ../home-manager/shell-environment.nix
  ];

  boot.blacklistedKernelModules = [
    "dvd_usb_rtl28xxu"
  ];

  networking = {
    hostName = "garage";
    useDHCP = false;
    networkmanager.enable = true;
    defaultGateway = {
      address = "192.168.8.1";
      interface = "enp2s0";
    };
    nameservers = [
      "192.168.8.1"
      "1.1.1.1"
      "8.8.8.8"
    ];
    interfaces = {
      en2ps0 = {
        useDHCP = true;
        ipv4.addresses = [
          { address = "192.168.8.10"; prefixLength = 21; }
        ];
      };
    };
  };

  hardware = {
    bluetooth.enable = true;
    rtl-sdr.enable = true;
  };

  sound.enable = true;

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  services = {
    blueman.enable = true; # bluetooth
  };

  environment.systemPackages = with pkgs; [
    rtl_433
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
}
