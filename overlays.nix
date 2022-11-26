/*
  Do we need to pass nixpkgs in or nixpkgs.legacyPackages.<arch> in?
  Yeah, probably need to pass in pkgs
*/
{ nixpkgs }:
{
  nixpkgs.overlays = [

    # wallpaper
    (final: prev: {
      wallpaper = import ./packages/wallpaper { pkgs = nixpkgs.legacyPackages.x86_64-linux; };
      })

    # pinentry
    (final: prev: {
      pinentry = prev.pinentry.override {
        enabledFlavors = [ "curses" ];
      };
    })

    # ble-thermometer-scan
    (final: prev: {
      ble-thermometer-scan = nixpkgs.legacyPackages.x86_64-linux.callPackage nixpkgs.legacyPackages.x86_64-linux.fetchFromGitHub {
        owner = "kaiju";
        repo = "ble-thermometer-scan";
        rev = "main";
        sha256 = "sha256-gx6k9oIzpVu/GT1LgLZg8hsczXD88niWEATKxN76I88=";
      };
    })

  ];
}
