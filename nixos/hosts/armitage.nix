{ pkgs, modulesPath, ... }:
let

  wrapper = pkgs.callPackage "${modulesPath}/../../pkgs/tools/networking/maubot/wrapper.nix" {
    unwrapped = fixedMaubot;
    python3 = pkgs.python311;
  };
  /* This is half of the battle, shoehorning in setuptools into maubot's
     python so mbc doesn't crash, next is getting the plugins to actually use this derivation */
  fixedMaubot = pkgs.maubot.overrideAttrs (final: prev: {
    propagatedBuildInputs = [ pkgs.python311.pkgs.setuptools ] ++ prev.propagatedBuildInputs;
    passthru = prev.passthru // {
      withPlugins = plugins: wrapper { inherit plugins; };
    };
  });

  /* Couldn't figure out how to directly override maubot.plugins so whatever. */
  fixedMaubotPlugins = fixedMaubot.plugins.override {
    maubot = fixedMaubot;
  };

in {
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
      "josh.mast.zone" = {};
      "kaiju.net" = {};
      "armitage.mast.zone" = {
        email = "josh@mast.zone";
      };
      "whylb.mast.zone" = {
        email = "josh@mast.zone";
      };
      "matrix.mast.zone" = {
        email = "josh@mast.zone";
      };
      "odon.mast.zone" = {
        email = "josh@mast.zone";
      };
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
      };
      "josh.mast.zone" = {
        enableACME = true;
        forceSSL = true;
        root = "/opt/websites/josh.mast.zone";
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
      };
    };
  };

  services.mastodon = {
    enable = true;
    localDomain = "mast.zone";
    configureNginx = false;
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
    streamingProcesses = 1;
    extraConfig = {
      "WEB_DOMAIN" = "odon.mast.zone";
      "SINGLE_USER_MODE" = "true";
    };
  };

  services.maubot = {
    enable = true;
    package = fixedMaubot;
    plugins = with fixedMaubotPlugins; [
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
    python310
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
