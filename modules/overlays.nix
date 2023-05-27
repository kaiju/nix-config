{ pkgs, ... }:
let

  ble-thermometer-scan = pkgs.fetchFromGitHub {
    owner = "kaiju";
    repo = "ble-thermometer-scan";
    rev = "main";
    sha256 = "sha256-/nxFGVC72xhGb9+omszuLDT/zGkhaomoNwjFe3/kjMU=";
  }; 

in {
  nixpkgs.overlays = [
    (final: prev: {

      /*
         Open question: What's the difference between
           pkgs.callPackage ../packages/wallpaper {}
         and
           import ../packages/wallpaper { inherit pkgs; }
         ?

         Answer: It's a convienence function, see: https://nixos.org/guides/nix-pills/callpackage-design-pattern.html#idm140737319882144
      */

      # Bring in our local derivation of wallpaper images
      wallpaper = prev.callPackage ../packages/wallpaper {};

      # Override pinentry to prevent it from building a bunch of unneccessary xorg packages
      pinentry = prev.pinentry.override {
        enabledFlavors = [ "curses" ];
      };

      # Add weechat-matrix plugin to weechat
      weechat = prev.weechat.override {
        configure = { availablePlugins, ...}: {
          scripts = [
            prev.weechatScripts.weechat-matrix
          ];
        };
      };

      /*
        Open Question:  why didn't this derivation actually build at first?

        Originally this was written as:

        ble-thermometer-scan = prev.callPackage prev.fetchFromGitHub { ... }

        and the result would add the derivation files itself to the nix store,
        referenced as `ble-thermometer-scan`, but not the actual built derivation.

        I _think_ this was a syntactical issue of not passing some addtional attrset
        arguments. Wrapping prev.fetchFromGitHub {} in parens ala:

        ble-thermometer-scan = prev.callPackage (prev.fetchFromGitHub { ... }) {}

        worked fine. In this case, we opted to assign fetchFromGitHub to a variable
        and pass it to callPackage that way.
      */

      # Add our ble-thermometer-scan derivation from GitHub
      ble-thermometer-scan = prev.callPackage ble-thermometer-scan {};

    })

  ];
}
