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
    act
    age
    k9s
    buildpack
    kubectl
    kubernetes-helm
    kustomize
    kubebuilder
    tektoncd-cli
    jq
    yq

    opentofu  # time to give this a shot
    terraform
    terraform-ls
    terraform-docs

    tilt
    ansible
    packer
    shellcheck
    awscli2
    google-cloud-sdk
    google-cloud-sql-proxy
    oci-cli
    postgresql_15
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
    go_1_21
    gotools
    golint
    gocode
    gopls
    delve
    go-tools

    pre-commit
    nodejs
    gcc
    rustup
    magic-wormhole-rs
    jsonnet
    gojsontoyaml
    jsonnet-bundler
    tanka
    dbmate
    mastpkgs.mkfatimg
  ];

}
