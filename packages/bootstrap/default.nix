{ pkgs ? import <nixpkgs> { } }:
pkgs.writeShellApplication {
  name = "bootstrap";
  runtimeInputs = [
    pkgs.bitwarden-cli
  ];
  text = ./bootstrap.sh;
}
