{ pkgs, modulesPath, ... }:
{
  networking = {
    defaultGateway = {
      address = "10.5.5.1";
      interface = "enp0s6";
    };
    enableIPv6 = true;
    nameservers = [
      "169.254.169.254"
    ];
    interfaces.enp0s6 = {
      useDHCP = true;
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
          name = "default";
          metrics_override = { prefix = "nginx"; };
          namespace_label = "vhost";
          format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\"";
          source = {
            files = [
              "/var/log/nginx/access.log"
            ];
          };
        }
        {
          name = "conduit";
          metrics_override = { prefix = "nginx"; };
          namespace_label = "vhost";
          format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\"";
          source = {
            files = [
              "/var/log/nginx/conduit-access.log"
            ];
          };
        }
        {
          name = "gts";
          metrics_override = { prefix = "nginx"; };
          namespace_label = "vhost";
          format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\"";
          source = {
            files = [
              "/var/log/nginx/gts-access.log"
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
      "mast.zone" = {};
      "josh.mast.zone" = {
        extraDomainNames = ["hire.josh.mast.zone"];
      };
      "kaiju.net" = {};
      "armitage.mast.zone" = {};
      "whylb.mast.zone" = {};
      "matrix.mast.zone" = {};
      "gts.mast.zone" = {};
    };
  };

  services.nginx = {
    enable = true;
    enableReload = true;
    statusPage = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "armitage.mast.zone" = {
        enableACME = true;
        default = true;
        forceSSL = true;
      };
      "mast.zone" = {
        enableACME = true;
        forceSSL = true;
        root = "/opt/websites/mast.zone";

        locations."/.well-known/matrix/" = {
          proxyPass = "http://[::1]:6167";
          extraConfig =  ''
            add_header Access-Control-Allow-Methods 'GET, POST, PUT, DELETE, OPTIONS';
            add_header Access-Control-Allow-Headers 'X-Requested-With, Content-Type, Authorization';
          '';
        };

        locations."/.well-known/webfinger" = {
          extraConfig = ''
            rewrite ^.*$ https://gts.mast.zone/.well-known/webfinger permanent;
          '';
        };

        locations."/.well-known/host-meta" = {
          extraConfig = ''
            rewrite ^.*$ https://gts.mast.zone/.well-known/host-meta permanent;
          '';
        };

        locations."/.well-known/nodeinfo" = {
          extraConfig = ''
            rewrite ^.*$ https://gts.mast.zone/.well-known/nodeinfo permanent;
          '';
        };

      };
      "josh.mast.zone" = {
        enableACME = true;
        forceSSL = true;
        root = "/opt/websites/josh.mast.zone";
      };
      "hire.josh.mast.zone" = {
        useACMEHost = "josh.mast.zone";
        forceSSL = true;
        root = "/opt/websites/josh.mast.zone/hire";
      };
      "kaiju.net" = {
        enableACME = true;
        forceSSL = true;
        root = "/opt/websites/kaiju.net";
      };
      "gts.mast.zone" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8090";
          extraConfig = ''
            client_max_body_size 40m;
            access_log /var/log/nginx/gts-access.log combined;
          '';
        };
      };
      "whylb.mast.zone" = {
        enableACME = true;
        forceSSL = true;
        root = "/opt/whylb/_site";
        basicAuthFile = "/opt/whylb/htpasswd";
      };
      "matrix.mast.zone" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://[::1]:6167";
          extraConfig = ''
            client_max_body_size 20m;
          '';
        };
        extraConfig = ''
          access_log /var/log/nginx/conduit-access.log combined;
        '';
      };
    };
  };
  users.users.nginx.extraGroups = ["mast"];

  services.gotosocial = {
    enable = true;
    settings = {
      host = "gts.mast.zone";
      account-domain = "mast.zone";
      bind-address = "127.0.0.1";
      port = 8090;
      db-type = "sqlite";
      db-address = "/var/lib/gotosocial/database.sqlite";
      storage-local-base-path = "/var/lib/gotosocial/storage";
    };
  };

  services.matrix-conduit = {
    enable = true;
    settings = {
      global = {
        server_name = "mast.zone";
        database_backend = "rocksdb";
        allow_encryption = true;
        allow_federation = true;
        allow_registration = false;
        trusted_servers = [
          "matrix.org"
        ];
        well_known_client = "https://matrix.mast.zone";
        well_known_server = "matrix.mast.zone:443";
      };
    };
  };

  services.maubot = {
    enable = true;
    package = pkgs.maubot;
    plugins = with pkgs.maubot.plugins; [
      rss
      dice
      reminder
      sed
    ];
    settings = {
      # maubot's management console isn't publically accessible so I'm just going to
      # look the other way about publishing a throw-away credential here
      admins = {
        root = "";
        admin = "admin";
      };
      database = "sqlite:maubot.db";
      homeservers = {
        "matrix.mast.zone" = {
          url = "https://matrix.mast.zone";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    jekyll
    screen
    python312
    weechat
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
