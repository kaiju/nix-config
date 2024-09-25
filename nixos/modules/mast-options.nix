{ lib, ... }:
{
  options = {

    mast.wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Wallpaper image";
    };

    mast.colors = lib.mkOption {
      type = lib.types.submodule {
        options = {
          # terminal colors
          background = lib.mkOption {
            type = lib.types.str;
          };
          foreground = lib.mkOption {
            type = lib.types.str;
          };
          black = lib.mkOption {
            type = lib.types.str;
          };
          red = lib.mkOption {
            type = lib.types.str;
          };
          green = lib.mkOption {
            type = lib.types.str;
          };
          yellow = lib.mkOption {
            type = lib.types.str;
          };
          blue = lib.mkOption {
            type = lib.types.str;
          };
          magenta = lib.mkOption {
            type = lib.types.str;
          };
          cyan = lib.mkOption {
            type = lib.types.str;
          };
          white = lib.mkOption {
            type = lib.types.str;
          };
          brightBlack = lib.mkOption {
            type = lib.types.str;
          };
          brightRed = lib.mkOption {
            type = lib.types.str;
          };
          brightGreen = lib.mkOption {
            type = lib.types.str;
          };
          brightYellow = lib.mkOption {
            type = lib.types.str;
          };
          brightBlue = lib.mkOption {
            type = lib.types.str;
          };
          brightMagenta = lib.mkOption {
            type = lib.types.str;
          };
          brightCyan = lib.mkOption {
            type = lib.types.str;
          };
          brightWhite = lib.mkOption {
            type = lib.types.str;
          };

          highlight = lib.mkOption {
            type = lib.types.str;
          };

        };
      };
    };

  };
  config = {

    # tokyo night
    mast.colors.background = "1a1b26";
    mast.colors.foreground = "a9b1d6";
    mast.colors.black = "32344a";
    mast.colors.red = "f7768e";
    mast.colors.green = "9ece6a";
    mast.colors.yellow = "e0af68";
    mast.colors.blue = "7aa2f7";
    mast.colors.magenta = "ad8ee6";
    mast.colors.cyan = "449dab";
    mast.colors.white = "787c99";
    mast.colors.brightBlack = "444b6a";
    mast.colors.brightRed = "ff7a93";
    mast.colors.brightGreen = "b9f27c";
    mast.colors.brightYellow = "ff9e64";
    mast.colors.brightBlue = "7da6ff";
    mast.colors.brightMagenta = "bb9af7";
    mast.colors.brightCyan = "0db9d7";
    mast.colors.brightWhite = "acb0d0";
  };
}
