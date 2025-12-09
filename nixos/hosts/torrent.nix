{ ... }:
let
  mullvadEndpoint = "146.70.168.130";
  mullvadPublicKey = "4Lg7yQlukAMp6EX+2Ap+q4O+QIV/OEZyybtFJmN9umw=";
  mullvadIP = "10.65.92.66/32";
in
{

  networking = {
    hostName = "torrent";
    useDHCP = false;
    networkmanager.enable = true;
    enableIPv6 = false;
    nameservers = [
      "192.168.8.1"
    ];
    interfaces.eth0 = {
      ipv4 = {
        addresses = [
          {
            address = "192.168.8.16";
            prefixLength = 22;
          }
        ];
        routes = [
          {
            address = mullvadEndpoint;
            prefixLength = 32;
            via = "192.168.8.1";
          }
        ];
      };
    };
    wireguard = {
      enable = true;
      interfaces.mullvad = {
        generatePrivateKeyFile = true;
        privateKeyFile = "/etc/wireguard/mullvad.key";
        ips = [
          mullvadIP
        ];
        peers = [
          {
            name = "mullvad";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = mullvadEndpoint + ":51820";
            publicKey = mullvadPublicKey;
          }
        ];
      };
    };
  };

  services.transmission = {
    enable = true;
    group = "mast";
    openFirewall = true;
    openRPCPort = true;
    openPeerPorts = true;
    settings = {
      download-dir = "/shared/downloads";
      incomplete-dir = "/shared/incomplete_downloads";
      watch-dir-enabled = true;
      watch-dir = "/shared/torrents";
      rpc-bind-address = "0.0.0.0";
      rpc-host-whitelist-enabled = false;
      rpc-whitelist = "192.168.8.*";
    };
  };

  fileSystems.torrents = {
    device = "shared";
    fsType = "virtiofs";
    mountPoint = "/shared";
  };

}
