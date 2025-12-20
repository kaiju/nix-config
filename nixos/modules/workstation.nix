/*
  Profile: workstation

  Common configuration for workstations
*/
{ pkgs, ... }:
{

  # NTFS support
  boot.supportedFilesystems = [
    "ntfs"
    "nfs"
  ];

  # provides gio so we can mount things
  environment.systemPackages = with pkgs; [ glib ];

  # allow us to build to aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

}
