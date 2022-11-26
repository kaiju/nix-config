{ pkgs, ... }:
{
  nixpkgs.overlays = [

    /* Bring in our package derivation from packages/wallpaper which provides us with images
       to use for desktop wallpaper */
    (final: prev: {
      /*
         Open question: What's the difference between
           pkgs.callPackage ../packages/wallpaper {}
         and
           import ../packages/wallpaper { inherit pkgs; }
         ?

         Answer: It's a convienence function, see: https://nixos.org/guides/nix-pills/callpackage-design-pattern.html#idm140737319882144
      */
      wallpaper = pkgs.callPackage ../packages/wallpaper {};
      })

    /* Override the nixpkgs pinentry module to prevent it from building a bunch of
       unneccessary xorg packages */
    (final: prev: {
      pinentry = prev.pinentry.override {
        enabledFlavors = [ "curses" ];
      };
    })

    /* Fetch our ble-thermometer-scan package from GitHub */
    (final: prev: {
      ble-thermometer-scan = pkgs.callPackage pkgs.fetchFromGitHub {
        owner = "kaiju";
        repo = "ble-thermometer-scan";
        rev = "main";
        sha256 = "sha256-gx6k9oIzpVu/GT1LgLZg8hsczXD88niWEATKxN76I88=";
      };
    })

    /* Add weechat-matrix into weechat */
    (final: prev: {
      weechat = prev.weechat.override {
        configure = { availablePlugins, ...}: {
          scripts = with prev.weechatScripts; [
            weechat-matrix
          ];
        };
      };
    })

  ];
}
