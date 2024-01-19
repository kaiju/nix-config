/*
  Profile: workstation

  Common configuration for workstations
*/
{ config, pkgs, ... }:
{

  # NTFS support
  boot.supportedFilesystems = [ "ntfs" ];

  # allow us to build to aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # I want to use this in homeConfigurations at some point
  home-manager.users.josh.home.packages = with pkgs.mastpkgs; [
    bootstrap
  ];

}
