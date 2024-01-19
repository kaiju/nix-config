{ config, pkgs, ... }:
{
  imports = [
    ../modules/server.nix
    ../modules/user-josh.nix
  ];

  environment.systemPackages = [
    pkgs.kubectl
    pkgs.k9s
  ];

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    defaultGateway = {
      address = "192.168.8.1";
      interface = "eth0";
    };
    nameservers = [
      "192.168.8.1"
    ];
    interfaces = {
      eth0.useDHCP = false;
      eth0.ipv4.addresses = [
        { address = "192.168.8.5"; prefixLength = 22; }
      ];
    };
    hostName = "k8s";
    firewall.allowedTCPPorts = [ 80 443 2222 ];
    firewall.trustedInterfaces = [
      "eth0"
      "cni0"
      "flannel.1"
    ];
  };

  fileSystems.volumes = {
    device = "k8s-volumes";
    fsType = "virtiofs";
    mountPoint = "/var/lib/rancher/k3s/storage";
  };

  services.k3s = {
    enable = true;
    extraFlags = "--disable=traefik --service-node-port-range=1025-32767";
  };

  services.prometheus.exporters.node.enable = pkgs.lib.mkOverride 10 false;

}
