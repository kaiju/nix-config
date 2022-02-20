{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    element-desktop
    tdesktop
    zoom-us
  ];
}
