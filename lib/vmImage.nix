/*
  thoughts -- can I get nixpkgs from nixosConfiguration?
  TODO -- pass in arguments to virt domain xml
*/
{ self, nixpkgs }:
{ nixosConfiguration, format ? "qcow2", diskSize ? "auto", additionalSpace ? "512M" }:
let
  hostName = nixosConfiguration.config.networking.hostName;
  virtDomain = builtins.readFile "${self}/domain-template.xml";
  diskImage = import "${nixpkgs}/nixos/lib/make-disk-image.nix" {
    lib = nixosConfiguration.pkgs.lib;
    config = nixosConfiguration.config;
    pkgs = nixosConfiguration.pkgs;
    inherit format diskSize additionalSpace;

    /*
    contents = [
      {
        source = "${self}/test-file";
        target = "/test-file";
        user = "0";
        group = "0";
      }
    ];
    */

  };
in nixosConfiguration.pkgs.stdenv.mkDerivation {
  name = "vm-image";
  unpackPhase = "true";
  env = {
    hostName = hostName;
  };
  installPhase = ''
    mkdir -p $out
    ln -s ${diskImage}/nixos.qcow2 $out/${hostName}.qcow2
    env > $out/env
    echo "${virtDomain}" > $out/${hostName}.xml
  '';
}
