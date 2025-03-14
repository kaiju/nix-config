{ config, pkgs, ... }:
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
    (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
      cloud-run-proxy
      terraform-tools
      gke-gcloud-auth-plugin
    ]))
    google-cloud-sql-proxy
    oci-cli

    postgresql_15
    
    #nodejs # can't figure out how to get sublime lsp-pyright to find the node runtime in the direnv, so here we go
    #terraform-ls # terraform language server

    # golang and tools
    #go_1_22
    #gotools
    #golint
    #gopls
    #delve
    #go-tools

    #pre-commit
    magic-wormhole-rs
    mastpkgs.mkfatimg
    duckdb
  ];

}
