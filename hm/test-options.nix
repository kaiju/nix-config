{ lib, ... }:
{
  options = {
    mast.honk = lib.mkOption {
      type = lib.types.str;
    };
  };
}
