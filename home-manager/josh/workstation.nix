# Additional things I want on my workstations
{ pkgs, ... }:
{

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    bitwarden-cli
    age
    jq
    yq
    magic-wormhole-rs
    mastpkgs.mkfatimg
    mastpkgs.bootstrap

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

    # duckdb via nix is a suckers game
    #duckdb
  ];

}
