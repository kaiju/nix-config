{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
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
    go_1_21
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
