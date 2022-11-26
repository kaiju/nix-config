{ pkgs, ... }:
{
  nixpkgs.overlays = [

    # wallpaper
    (final: prev: {
      wallpaper = import ./packages/wallpaper { inherit pkgs; };
      })

    # pinentry
    (final: prev: {
      pinentry = prev.pinentry.override {
        enabledFlavors = [ "curses" ];
      };
    })

    # ble-thermometer-scan
    (final: prev: {
      ble-thermometer-scan = pkgs.callPackage pkgs.fetchFromGitHub {
        owner = "kaiju";
        repo = "ble-thermometer-scan";
        rev = "main";
        sha256 = "sha256-gx6k9oIzpVu/GT1LgLZg8hsczXD88niWEATKxN76I88=";
      };
    })

  ];
}
