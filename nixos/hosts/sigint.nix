{ pkgs, ... }:
{
  imports = [
    ../modules/server.nix
    ../modules/bluetooth.nix
    ../modules/sdr.nix
    ../modules/users/josh.nix
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
          {
            address = "192.168.8.10";
            prefixLength = 21;
          }
        ];
      };
    };
  };

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

}
