{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # cloud tools
    aws-vault
    k9s
    kubernetes-helm
    argocd
    tektoncd-cli
    jq
    terraform
    terraform-ls
    terraform-docs
    ansible
    packer
    shellcheck
    awscli2
    google-cloud-sdk
  ];

  # Enable pass for aws-vault
  programs.password-store.enable = true;
  services.pass-secret-service.enable = true;

  home.sessionVariables = {
    AWS_VAULT_BACKEND = "pass";
  };
}
