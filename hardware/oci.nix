{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "virtio_scsi" "usbhid" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;  # Try not to fill up /boot
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "console=ttyS0" ];
  systemd.services."serial-getty@ttyS0".enable = true;

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];

}
