{ lib, ... }:
{
  options = {
    mast.wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Wallpaper image";
    };
  };
}
