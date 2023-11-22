{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityFile ~/.ssh/josh@mast.zone.key
    '';
    # wonder if we can just build this out of all our flake outputs?
    matchBlocks = {
      "mast.zone" = {
        hostname = "mast.zone";
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
