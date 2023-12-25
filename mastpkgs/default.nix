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
    rev = "ebe86c819cf47296a31b765db8df629ad12b623e";
    sha256 = "sha256-6lcBusordzaoilWJoseDbaxuU5Vv06jHTVRq6KU2ERo=";
  };
in {
  wallpaper = pkgs.callPackage ./wallpaper {};
  bootstrap = pkgs.callPackage ./bootstrap {};
  ble-thermometer-scan = pkgs.callPackage ble-thermometer-scan {};
  mkfatimg = pkgs.callPackage mkfatimg {};
}
