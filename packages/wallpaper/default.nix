{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "wallpapers";
  src = ./.;
  installPhase = ''
    mkdir -p $out
    cp ./*.jpg $out
  '';
}
