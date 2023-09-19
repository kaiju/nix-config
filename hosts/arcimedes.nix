{ config, lib, pkgs, modulesPath, ... }:
{
  # hardware
  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  home-manager.users.josh.imports = [
    ../home-manager/dev-tools.nix
    ../home-manager/ssh-config.nix
    ../home-manager/neovim.nix
  ];

  # host specific config
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "arcimedes";

  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
  ];

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    libva-utils
    hwinfo
  ];

  services.openssh.enable = true;

}
