{ ... }:
{

  # -- observability
  services.alloy = {
    enable = true;
  };

  environment.etc."alloy/config.alloy" = {
    text = ''

      prometheus.exporter.unix "node" { }

      prometheus.scrape "node" {
        targets = prometheus.exporter.unix.node.targets
        forward_to = [prometheus.remote_write.ops.receiver]
      }

      prometheus.remote_write "ops" {
        endpoint {
          url = "http://ops.mast.haus:9090/api/v1/write"
        }
      }

      loki.relabel "journal" {
        forward_to = []

        rule {
          source_labels = ["__journal__hostname"]
          target_label = "host"
        }

        rule {
          source_labels = ["__journal__systemd_unit"]
          target_label = "unit"
        }

        rule {
          source_labels = ["__journal__transport"]
          target_label = "transport"
        }

      }

      loki.source.journal "read" {
        forward_to = [loki.write.default.receiver]
        relabel_rules = loki.relabel.journal.rules
      }

      loki.write "default" {
        endpoint {
          url = "http://ops.mast.haus:3100/api/prom/push"
        }
      }
    '';
  };

}
