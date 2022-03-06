{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    ble-thermometer-scan.url = "github:kaiju/ble-thermometer-scan";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: (
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        packages.wallpaper = import ./wallpaper { inherit pkgs; };
      }
    )
  ) // {

    overlays = {
      wallpaper = (final: prev: { wallpaper = self.packages.${prev.system}.wallpaper; });
      ble-thermometer-scan = inputs.ble-thermometer-scan.overlay;
    };

  };
}
