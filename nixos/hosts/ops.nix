{ config, pkgs, ... }:
{

  networking = {
    hostName = "ops";
    useDHCP = false;
    defaultGateway = {
      address = "192.168.8.1";
      interface = "eth0";
    };
    nameservers = [
      "192.168.8.1"
    ];
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "192.168.8.4"; prefixLength = 22; }
        ];
      };
    };
    firewall.allowedTCPPorts = [ 80 443 9000 9001 ];
  };

  security.acme = {
    defaults = {
      email = "josh@mast.zone";
      dnsProvider = "route53";
      dnsResolver = "1.1.1.1:53";
      environmentFile = "/run/credentials/aws-dns-manager-env";
    };
    acceptTerms = true;
    certs = {
      "ops.mast.haus" = {
        group = "nginx";
      };
      "git.mast.haus" = {
        group = "nginx";
      };
      "s.mast.haus" = {
        group = "nginx";
        extraDomainNames = [
          "*.s.mast.haus"
        ];
      };
      "c.mast.haus" = {
        group = "nginx";
      };
    };
  };

  services.nginx = {
    enable = true;
    enableReload = true;
    statusPage = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "ops.mast.haus" = {
        default = true;
        forceSSL = true;
        useACMEHost = "ops.mast.haus";
        locations."/" = {
          proxyPass = "http://localhost:3000";
        };
      };
      "git.mast.haus" = {
        forceSSL = true;
        useACMEHost = "git.mast.haus";
        locations."/" = {
          proxyPass = "http://localhost:3000";
        };
      };
      "c.mast.haus" = {
        forceSSL = true;
        useACMEHost = "c.mast.haus";
        locations."/" = {
          proxyPass = "http://localhost:5000";
        };
      };
      "s.mast.haus" = {
        forceSSL = true;
        useACMEHost = "s.mast.haus";
        locations."/" = {
          proxyPass = "http://localhost:9001";
          proxyWebsockets = true;
        };
      };
      "*.s.mast.haus" = {
        forceSSL = true;
        useACMEHost = "s.mast.haus";
        locations."/" = {
          proxyPass = "http://localhost:9000";
        };
      };
    };
  };

  users.users.git = {
    description = "Gitea Service";
    home = config.services.gitea.stateDir;
    useDefaultShell = true;
    group = config.services.gitea.group;
    isSystemUser = true;
  };

  services.gitea = {
    enable = true;
    user = "git";
    settings = {
      server = {
        DOMAIN = "git.mast.haus"; 
        ROOT_URL = "https://git.mast.haus/";
      };
      migrations = {
        ALLOW_LOCALNETWORKS = "true";
      };
    };
  };

  virtualisation.docker.enable = true;

  services.dockerRegistry = {
    enable = true;
    enableGarbageCollect = true;
    enableDelete = true;
  };

  services.minio = {
    enable = true;
  };
  systemd.services.minio.environment.MINIO_DOMAIN = "s.mast.haus";
  systemd.services.minio.environment.MINIO_BROWSER_REDIRECT_URL = "https://s.mast.haus";
  #systemd.services.minio.environment.MINIO_SERVER_URL = "https://s.mast.haus";

  services.gitea-actions-runner = {
    instances.ops = {
      enable = true;
      url = "https://git.mast.haus/";
      name = "ops-runner";
      token = "ZVU7Vv6pXtxePsjbSZ0hXudUksdT8kpBhQ3TDHB8";
      labels = [
        "ubuntu-latest:docker://node:18-bullseye"
      ];
    };
  };

}
