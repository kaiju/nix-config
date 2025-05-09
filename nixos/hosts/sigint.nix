{ config, pkgs, ... }:
{
  imports = [
    ../modules/bluetooth.nix
    ../modules/sdr.nix
    ../modules/user-josh.nix
  ];

  networking = {
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
      ExecStart = ''${pkgs.rtl_433}/bin/rtl_433 -Y classic -C si -f 915M -F mqtt:192.168.8.5:1883'';
    };
  };

  # TODO -- why is this broken since I switched up how I pull ble-thermometer-scan in?
  # It's not building the actual package :(
  # I'm doing the imports wrong somehow :(
  systemd.services.ble-thermometer-scan = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "bluetooth.target" ];
    description = "BLE Thermometer Scanner";
    path = [
    	pkgs.bluez
    ];
    serviceConfig = {
      Type = "simple";
      User = "root";
      ExecStart = ''${pkgs.mastpkgs.ble-thermometer-scan}/bin/ble-thermometer-scan 192.168.8.5'';
      Restart = "on-failure";
    };
  };

}
