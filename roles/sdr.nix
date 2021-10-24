{ config, pkgs, ... }:
{
  hardware.rtl-sdr.enable = true;
  boot.blacklistedKernelModules = [ "dvd_usb_rtl28xxu" ];
}
