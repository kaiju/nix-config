{ config, pkgs, ... }:
{
  imports = [
    ../modules/server.nix
    ../modules/user-josh.nix
  ];

  networking = {
    useDHCP = false;
    enableIPv6 = false;
    interfaces = {
      ens3 = {
        useDHCP = true;
      };
    };

    wireguard = {
      enable = true;
      interfaces.wg0 = {
        generatePrivateKeyFile = true;
        privateKeyFile = "/etc/wireguard/private_key";
        ips = [ "192.168.12.20/32" ];
        peers = [
          {
            allowedIPs = [ "192.168.0.0/16" ];
            publicKey = "Xkdgk9fWNWtF5pe9Q7hHLyLaqPRr6zN9rgl71iwYvkc=";
            endpoint = "masthaus.duckdns.org:51900";
          }
        ];
        #postSetup = ''
        #  resolvectl dns wg0 192.168.12.1
        #'';
      };
    };

    firewall.trustedInterfaces = [
      "wg0" # wireguard
    ];

  };

  environment.systemPackages = with pkgs; [
    weechat
    nmap
  ];

  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "no";

}
