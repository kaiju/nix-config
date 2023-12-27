{ pkgs ? import <nixpkgs> }:
let
  ble-thermometer-scan = pkgs.fetchFromGitHub {
    owner = "kaiju";
    repo = "ble-thermometer-scan";
    rev = "main";
    sha256 = "sha256-xcYXH7TaO12d7Fxr4sQdjXWyHaandEZG2HK8s2OFKPA=";
  };
  mkfatimg = pkgs.fetchFromGitHub {
    owner = "kaiju";
    repo = "mkfatimg";
    rev = "9431e347e56f9eea53fd28fc60dbe50665a2705f";
    sha256 = "sha256-hbQNORfgrJcY81FPKMd2ZH98CrVwnFurnC+tXmT1TjI=";
  };
in {
  wallpaper = pkgs.callPackage ./wallpaper {};
  bootstrap = pkgs.callPackage ./bootstrap {};
  ble-thermometer-scan = pkgs.callPackage ble-thermometer-scan {};
  mkfatimg = pkgs.callPackage mkfatimg {};
}
