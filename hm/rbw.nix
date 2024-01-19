{ config, pkgs, ... }:
{
  programs.rbw = {
    enable = true;
    settings = {
      email = "josh@mast.zone";
      pinentry = "curses";
    };
  };
}
