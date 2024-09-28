  [
    (final: prev: {

      mastpkgs = prev.callPackage ../mastpkgs {};

      /*
         Open question: What's the difference between
           pkgs.callPackage ../packages/wallpaper {}
         and
           import ../packages/wallpaper { inherit pkgs; }
         ?

         Answer: It's a convienence function, see: https://nixos.org/guides/nix-pills/callpackage-design-pattern.html#idm140737319882144
      */

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

      ollama = prev.ollama.overrideAttrs {
        version = "0.3.12";
      };

  })
]
