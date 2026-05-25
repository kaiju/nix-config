{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obsidian
  ];
  services.syncthing.enable = true;
}
