{ pkgs, config, ... }:
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
          {
            address = "192.168.8.4";
            prefixLength = 22;
          }
        ];
      };
    };
    firewall.allowedTCPPorts = [
      80
      443
      3333
      3100
      9000
      9001
      9090
    ];
  };

  security.acme = {
    defaults = {
      email = "josh@mast.zone";
      dnsProvider = "route53";
      dnsResolver = "1.1.1.1:53";
      credentialFiles = {
        AWS_SHARED_CREDENTIALS_FILE = "/var/lib/acme/dns-manager-aws-credentials";
      };
      environmentFile = "/var/lib/acme/dns-manager-aws-environment";
    };
    acceptTerms = true;
    certs = {

      "new-grafana.mast.haus" = {
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

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 3333;
        http_addr = "0.0.0.0";
      };
      "auth.anonymous" = {
        enabled = true;
        org_role = "Admin";
      };
    };
    provision = {
      enable = true;
      datasources = {
        settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://ops.mast.haus:9090";
          }
          {
            name = "Loki";
            type = "loki";
            url = "http://ops.mast.haus:3100";
          }
        ];
      };
    };
  };

  services.nginx = {
    enable = true;
    enableReload = true;
    statusPage = true;
    recommendedProxySettings = true;
    virtualHosts = {

      "new-grafana.mast.haus" = {
        forceSSL = true;
        useACMEHost = "new-grafana.mast.haus";
        locations."/" = {
          proxyPass = "http://localhost:3333";
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

  # services

  services.prometheus = {
    enable = true;
    retentionTime = "365d";
    extraFlags = [ "--web.enable-remote-write-receiver" ];
    # TODO- metric relabelling
    scrapeConfigs = [
      {
        job_name = "node-exporter";
        static_configs = [
          {
            targets = [
              "router.mast.haus:9100"
            ];
          }
        ];
      }
    ];
  };

  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false;
      server = {
        http_listen_address = "0.0.0.0";
        http_listen_port = 3100;
        grpc_listen_port = 9096;
        log_level = "info";
        grpc_server_max_concurrent_streams = 1000;
      };
      compactor = {
        retention_enabled = true;
        delete_request_store = "filesystem";
        working_directory = "/var/lib/loki/retention";
        compaction_interval = "10m";
        retention_delete_delay = "2h";
        retention_delete_worker_count = 150;

      };
      limits_config = {
        retention_period = "720h";
        max_label_names_per_series = 25;
      };
      common = {
        instance_addr = "127.0.0.1";
        path_prefix = "/var/lib/loki";
        storage = {
          filesystem = {
            chunks_directory = "/var/lib/loki/chunks";
            rules_directory = "/var/lib/loki/rules";
          };
        };
        replication_factor = 1;
        ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };
      query_range = {
        results_cache = {
          cache = {
            embedded_cache = {
              enabled = true;
              max_size_mb = 100;
            };
          };
        };
      };
      schema_config = {
        configs = [
          {
            from = "2020-10-24";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };
      pattern_ingester = {
        enabled = true;
        metric_aggregation = {
          loki_address = "localhost:3100";
        };
      };
      ruler = {
        alertmanager_url = "http://localhost:9093"; # haha this wont work
      };
      frontend = {
        encoding = "protobuf";
      };
      storage_config = {
        filesystem = {
          directory = "/var/lib/loki/data";
        };
      };
    };
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

  services.garage = {
    enable = true;
    package = pkgs.garage_2;
    settings = {
      replication_factor = 1;
      rpc_secret = "1c080a02dec0f0992c1f39b9497558458f9b36e5050a025077af6c55e81b0b85";
      rpc_bind_addr = "[::]:3901";

      s3_api = {
        api_bind_addr = "[::]:3900";
        s3_region = "garage";
        root_domain = ".s3.garage";
      };

      s3_web = {
        bind_addr = "[::]:3902";
        root_domain = ".web.garage";
        index = "index.html";
      };

      k2v_api = {
        api_bind_addr = "[::]:3904";
      };

      admin = {
        api_bind_addr = "[::]:3903";
        admin_token = "UyiGgcHYMpCeMcAfln8f05oeOypFSJbwQSj3B0JVjJA=";
        metrics_token = "tqrlUwLmtJ2lxP43tmcpl6SDH7/ZzVwJUnnIXyazZtU=";
      };

    };
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
