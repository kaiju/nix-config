{
  pkgs ? import <nixpkgs>,
}:
let
  ble-thermometer-scan =
    (builtins.getFlake "github:kaiju/ble-thermometer-scan/ee703109693d0a951932d9ba0334a0e938122f03")
    .packages.${pkgs.system}.ble-thermometer-scan;
  mkfatimg = pkgs.fetchFromGitHub {
    owner = "kaiju";
    repo = "mkfatimg";
    rev = "9431e347e56f9eea53fd28fc60dbe50665a2705f";
    sha256 = "sha256-hbQNORfgrJcY81FPKMd2ZH98CrVwnFurnC+tXmT1TjI=";
  };
in
{
  wallpaper = pkgs.callPackage ./wallpaper { };
  bootstrap = pkgs.callPackage ./bootstrap { };
  ble-thermometer-scan = ble-thermometer-scan;
  mkfatimg = pkgs.callPackage mkfatimg { };
}
