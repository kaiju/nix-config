{ pkgs ? import <nixpkgs> }:
let
  ble-thermometer-scan = pkgs.fetchFromGitHub {
    owner = "kaiju";
    repo = "ble-thermometer-scan";
    rev = "main";
    sha256 = "sha256-xcYXH7TaO12d7Fxr4sQdjXWyHaandEZG2HK8s2OFKPA=";
  };
in {
  wallpaper = pkgs.callPackage ./wallpaper {};
  bootstrap = pkgs.callPackage ./bootstrap {};
  ble-thermometer-scan = pkgs.callPackage ble-thermometer-scan {};
}
