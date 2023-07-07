{ config, pkgs, ... }:
let
  mullvadEndpoint = "";
  mullvadPublicKey = "";
  mullvadIP = "";
in {

  networking = {
    hostName = "torrent";
    useDHCP = false;
    networkmanager.enable = true;
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
          address = mullvadEndpoint; 
          prefixLength = 32;
          via = "192.168.8.1";
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
            allowedIPs = ["0.0.0.0/0"];
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
      download-dir = "/torrents/torrent_downloads";
      incomplete-dir = "/torrents/torrent_downloads/incomplete";
      watch-dir-enabled = true;
      watch-dir = "/torrents/torrent_files";
      rpc-bind-address = "0.0.0.0";
      rpc-host-whitelist-enabled = false;
      rpc-whitelist = "192.168.8.*";
    };
  };

  fileSystems.torrents = {
    device = "torrents";
    fsType = "virtiofs";
    mountPoint = "/torrents";
  };

}
