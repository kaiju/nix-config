{ pkgs, ... }:
{

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        load_dotenv = true;
        strict_env = true;
      };
    };
  };

  home.packages = with pkgs; [
    age # encryption tool
    jq
    yq
    shellcheck

    # cloud tools
    awscli2
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components;
      [
        cloud-run-proxy
        terraform-tools
        gke-gcloud-auth-plugin
      ]
    ))
    google-cloud-sql-proxy
    oci-cli

    postgresql_15

    magic-wormhole-rs
    mastpkgs.mkfatimg
    duckdb
  ];

}
