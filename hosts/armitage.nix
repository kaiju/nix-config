{ pkgs, ... }:
{
  networking = {
    defaultGateway = {
      address = "10.5.5.1";
      interface = "enp0s6";
    };
    nameservers = [
      "169.254.169.254"
    ];
    interfaces.enp0s6 = {
      ipv4.addresses = [
        { address = "10.5.5.203"; prefixLength = 24; }
      ];
    };

    firewall.allowedTCPPorts = [ 80 443 ];
  };

  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

  services.prometheus.exporters.nginxlog = {
    enable = true;
    openFirewall = true;
    user = "nginx";
    settings = {
      namespaces = [
        {
          name = "access";
          format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\"";
          source = {
            files = [
              "/var/log/nginx/access.log"
            ];
          };
        }
      ];
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "josh@mast.zone";
      webroot = "/var/lib/acme/acme-challenge";
    };
    certs = {
      "armitage.mast.zone" = {
        email = "josh@mast.zone";
      };
      "whylb.mast.zone" = {
        email = "josh@mast.zone";
      };
    };
  };

  services.nginx = {
    enable = true;
    enableReload = true;
    statusPage = true;
    virtualHosts = {
      "armitage.mast.zone" = {
        enableACME = true;
        default = true;
        forceSSL = true;
      };
      "whylb.mast.zone" = {
        enableACME = true;
        forceSSL = true;
        root = "/opt/whylb/_site";
        basicAuthFile = "/opt/whylb/htpasswd";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    jekyll
    screen
    python310
  ];

  users.groups.whylb = {
    gid = 1003;
  };

  users.users.josh.extraGroups = [ "whylb" ];

  users.users.kobek = {
    isNormalUser = true;
    extraGroups = [ "users" "whylb" ];
    shell = pkgs.bash;
  };

  systemd.tmpfiles.rules = [
    "d /opt/whylb 2775 josh whylb -"
    "A /opt/whylb - - - - d:group:whylb:rwx"
    "L /home/josh/whylb - - - - /opt/whylb"
    "L /home/kobek/whylb - - - - /opt/whylb"
  ];

}
