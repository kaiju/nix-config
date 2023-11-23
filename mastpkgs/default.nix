{ pkgs ? import <nixpkgs> }:
let
  ble-thermometer-scan = pkgs.fetchFromGitHub {
    owner = "kaiju";
    repo = "ble-thermometer-scan";
    rev = "main";
    sha256 = "sha256-/nxFGVC72xhGb9+omszuLDT/zGkhaomoNwjFe3/kjMU=";
  };
in {
  wallpaper = pkgs.callPackage ./wallpaper {};
  bootstrap = pkgs.callPackage ./bootstrap {};
  ble-thermometer-scan = pkgs.callPackage ble-thermometer-scan {};
}
