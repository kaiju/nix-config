{
  pkgs ? import <nixpkgs> { },
}:
pkgs.stdenv.mkDerivation {
  name = "plate";
  src = ./src;
  buildCommand = ''
    mkdir -p $out/bin
    cp $src/* $out/bin
    ln -s $out/bin/plate.sh $out/bin/plate
  '';
}
