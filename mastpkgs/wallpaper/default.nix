{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "wallpaper";
  version = "0.1";
  src = ./.;
  installPhase = ''
    mkdir -p $out
    cp ./*.jpg $out
    cp ./*.png $out
  '';
}
