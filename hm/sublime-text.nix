{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    sublime4
  ];
  
  # TODO -- dump out some initial config
}
