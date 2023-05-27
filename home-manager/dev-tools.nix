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
    ansible
    packer
    shellcheck
    awscli2
    google-cloud-sdk
    cloud-sql-proxy
    postgresql
    (python3.withPackages (p: with p; [
      pip
      keyring
      keyrings-google-artifactregistry-auth
      flake8
      twine
      wheel
    ]))
    pylint
    black
    poetry
    go_1_18
    pre-commit
    nodejs
    gcc
    rustup
    magic-wormhole-rs
    jsonnet
    gojsontoyaml
    jsonnet-bundler
    tanka
  ];

}
