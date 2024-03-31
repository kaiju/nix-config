{ config, pkgs, ... }:
{
  programs.rbw = {
    enable = true;
    settings = {
      email = "josh@mast.zone";
      pinentry = pkgs.pinentry-curses;
    };
  };
}
