{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    # wonder if we can just build this out of all our flake outputs?
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
      "sigint" = {
        hostname = "sigint.mast.haus";
        forwardAgent = true;
      };
    };
  };
}
