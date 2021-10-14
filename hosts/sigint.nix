{ config, pkgs, ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/efi-boot.nix
    ../roles/server.nix
    ../roles/bluetooth.nix
    ../roles/user-josh.nix
  ];

  networking = {
    hostName = "sigint";
    networkmanager.enable = true;
    useDHCP = false;
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
      enp2s0 = {
        useDHCP = false;
        ipv4.addresses = [
          { address = "192.168.8.10"; prefixLength = 21; }
        ];
      };
    };
  };

  sound.enable = true;

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  # SDR who-whats-its
  hardware = {
    rtl-sdr.enable = true;
  };

  boot.blacklistedKernelModules = [
    "dvd_usb_rtl28xxu"
  ];

  environment.systemPackages = with pkgs; [
    rtl_433
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
