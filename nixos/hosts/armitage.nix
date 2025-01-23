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
          name = "mastodon";
          metrics_override = { prefix = "nginx"; };
          namespace_label = "vhost";
          format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\"";
          source = {
            files = [
              "/var/log/nginx/mastodon-access.log"
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
      "odon.mast.zone" = {};
    };
  };

  services.nginx = {
    enable = true;
    enableReload = true;
    statusPage = true;
    recommendedProxySettings = true;
    upstreams = {
      mastodon-streaming = {
        extraConfig = ''
          least_conn;
        '';
        servers = {
          "unix:/run/mastodon-streaming/streaming-1.socket" = {};
        };
      };
    };
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
      "odon.mast.zone" = {
        enableACME = true;
        forceSSL = true;
        root = "${pkgs.mastodon}/public/";

        locations."/system/".alias = "/var/lib/mastodon/public-system/";

        locations."/" = {
          tryFiles = "$uri @proxy";
        };

        locations."@proxy" = {
          proxyPass = "http://unix:/run/mastodon-web/web.socket";
          proxyWebsockets = true;
        };

        locations."/api/v1/streaming/" = {
          proxyPass = "http://mastodon-streaming";
          proxyWebsockets = true;
        };

        extraConfig = ''
          client_max_body_size 20m;
          access_log /var/log/nginx/mastodon-access.log combined;
        '';

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
  users.users.nginx.extraGroups = ["mastodon" "mast"];

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

  services.mastodon = {
    enable = true;
    localDomain = "mast.zone";
    configureNginx = false;
    smtp = {
      authenticate = true;
      createLocally = false;
      fromAddress = "notifications@odon.mast.zone";
      host = "smtp.mailgun.org";
      port = 587;
      user = "postmaster@odon.mast.zone";
      passwordFile = "/var/lib/mastodon/secrets/smtp-password";
    };
    streamingProcesses = 1;
    extraConfig = {
      "WEB_DOMAIN" = "odon.mast.zone";
      "SINGLE_USER_MODE" = "true";
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
