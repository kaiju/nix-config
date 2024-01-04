{ pkgs, config, ... }:
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
      "matrix.mast.zone" = {
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
      "matrix.mast.zone" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:6167";
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
      };
    };
  };

  services.mastodon = {
    enable = true;
    localDomain = "social.mast.zone";
    configureNginx = true;
    mediaAutoRemove.enable = false;
    smtp = {
      authenticate = true;
      createLocally = false;
      fromAddress = "notifications@odon.mast.zone";
      host = "smtp.mailgun.org";
      port = 587;
      user = "postmaster@odon.mast.zone";
      passwordFile = "/var/lib/mastodon/secrets/smtp-password";
    };
    streamingProcesses = 3;
  };

  services.maubot = {
    enable = true;
    plugins = with config.services.maubot.package.plugins; [
      rss
    ];
    settings = {
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
