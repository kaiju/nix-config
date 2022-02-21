{ config, pkgs, lib, ... }:
{
  nixpkgs.config.permittedInsecurePackages = [
    "electron-13.6.9"
  ];
  home.packages = with pkgs; [
    obsidian
  ];
  services.syncthing.enable = true;
}
