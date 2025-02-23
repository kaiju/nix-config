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
    k9s 
    kubectl
    jq
    yq

    #opentofu  # time to give this a shot
    #terraform
    terraform-ls # terraform language server (go in nvim?)
    #terraform-docs

    #tilt # should probably go in project
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

    # python tools
    (python311.withPackages (p: with p; [
      pip
      keyring
      #keyrings-google-artifactregistry-auth # -- broken
      flake8
      twine
      wheel
    ]))
    pylint
    black
    poetry
    mypy

    # golang and tools
    go_1_22
    gotools
    golint
    gopls
    delve
    go-tools

    pre-commit

    #nodejs # in project
    #gcc # in project
    #rustup # in project

    magic-wormhole-rs
    #dbmate # in project
    mastpkgs.mkfatimg
    duckdb
  ];

}
