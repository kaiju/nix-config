{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "gojira.kaiju.net" = {
        hostname = "gojira.kaiju.net";
        forwardAgent = true;
      };
      "straylight" = {
        hostname = "straylight.mast.haus";
        forwardAgent = true;
      };
      "daedalus" = {
        hostname = "daedalus.mast.haus";
        forwardAgent = true;
      };
    };
  };
}
