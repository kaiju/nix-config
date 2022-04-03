{ nixpkgs, config, lib, pkgs, ... }:
{
  imports = [
    "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
  ];

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

    system.build.rawimage = import "${nixpkgs}/nixos/lib/make-disk-image.nix" {
      inherit lib config pkgs;
      format = "raw"
    };

    system.build.qcow2image = import "${nixpkgs}/nixos/lib/make-disk-image.nix" {
      inherit lib config pkgs;
      format = "qcow2"
    };

  };
}


