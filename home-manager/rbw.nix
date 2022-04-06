{ config, pkgs, ... }:
{
  programs.rbw = {
    enable = true;
    settings = {
      email = "josh@kaiju.net";
      pinentry = "curses";
    };
  };
}
