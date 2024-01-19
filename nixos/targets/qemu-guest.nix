{ config, lib, pkgs, modulesPath, ... }:
let
in {

  imports = [
    "${toString modulesPath}/profiles/qemu-guest.nix"
  ];

  options = {};

  config = {

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };
    
    boot.growPartition = true;
    boot.kernelParams = [ "console=ttyS0" ];
    boot.loader.grub.device = "/dev/vda";
    boot.loader.timeout = 0;

    services.qemuGuest.enable = true;
    systemd.services."serial-getty@ttyS0".enable = true;

    # TODO: write system.build.vm here
    # Reference existing system.build.vm from virtualisations
    # system.build.vm = pkgs.runCommand "nixos-vm" {} ''
    # ''

    system.build.rawimage = import "${toString modulesPath}/../lib/make-disk-image.nix" {
      inherit lib config pkgs;
      format = "raw";
    };

    system.build.qcow2image = import "${toString modulesPath}/../lib/make-disk-image.nix" {
      inherit lib config pkgs;
      format = "qcow2";
      additionalSpace = "100G";
    };

  };

}

