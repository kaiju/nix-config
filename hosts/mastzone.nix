{ config, pkgs, ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/server.nix
    ../roles/user-josh.nix
  ];

  networking = {
    useDHCP = false;
    interfaces = {
      ens3 = {
        useDHCP = true;
      };
    };
    hostName = "mastzone";

    extraHosts = ''
      git.mast.haus     192.168.8.50
    '';

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
            endpoint = "mast.haus:51900";
          }
        ];
      };
    };

    firewall.trustedInterfaces = [
      "wg0" # wireguard
      "cni0" # K8s
      "flannel.1" # K8s
    ];

  };

  # lmao?
  nixpkgs.overlays = [
    (self: super:
      {
        weechat = super.weechat.override {
          configure = { availablePlugins, ... }: {
            scripts = with super.weechatScripts; [
              weechat-matrix
            ];
          };
        };
      }
    )
  ];

  environment.systemPackages = with pkgs; [
    weechat
    nmap
    kubectl
  ];

  # K8s
  services.k3s.enable = true;
  # --resolv-conf /run/systemd/resolve/resolv.conf is used in ?? with systemd-resolved, to prevent coredns from falling over:
  # https://github.com/k3s-io/k3s/issues/4087
  services.k3s.extraFlags = "--disable=traefik --resolv-conf /run/systemd/resolve/resolv.conf --service-node-port-range=1025-32767";
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.resolved.enable = true;
  services.resolved.fallbackDns = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

}
