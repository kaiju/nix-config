/*
  Profile: workstation

  Common configuration for workstations
*/
{ ... }:
{

  # NTFS support
  boot.supportedFilesystems = [ "ntfs" ];

  # allow us to build to aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

}
