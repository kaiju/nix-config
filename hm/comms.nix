{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    element-desktop
    zoom-us
    signal-desktop
    nheko
    slack
  ];
}
