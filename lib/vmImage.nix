{ self, nixpkgs }:
{ nixosConfiguration, format ? "qcow2"}: (import "${nixpkgs}/nixos/lib/make-disk-image.nix" {
  lib = nixosConfiguration.pkgs.lib;
  config = nixosConfiguration.config;
  pkgs = nixosConfiguration.pkgs;
  inherit format;
  """
  contents = [
    {
      source = "${self}/test-file";
      target = "/test-file";
      user = "0";
      group = "0";
    }
  ];
  """
})
