{ config, pkgs, ... }:
{
  imports = [
    ../modules/users/josh.nix
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

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
        {
          address = "192.168.8.5";
          prefixLength = 22;
        }
      ];
    };
    hostName = "k8s";
    firewall.allowedTCPPorts = [
      80
      443
      2222
    ];
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

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;
    ensureDatabases = [ "postgres" ];
    authentication = ''
      local all postgres peer map=superuser_map
    '';
    identMap = ''
      superuser_map root postgres
      superuser_map postgres postgres
      superuser_map josh postgres
    '';
  };

  services.k3s = {
    enable = true;
    extraFlags = "--datastore-endpoint=postgresql://postgres:@/k8s --disable=traefik --service-node-port-range=1025-32767";
  };

}
