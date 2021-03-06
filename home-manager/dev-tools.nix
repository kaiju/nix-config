{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # cloud tools
    k9s
    kubectl
    kubernetes-helm
    kustomize
    kubebuilder
    argocd
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
    python3
    go_1_17
    pre-commit
    nodejs
    gcc
    rustup
  ];

}
