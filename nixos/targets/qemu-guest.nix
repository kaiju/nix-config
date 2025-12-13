{
  modulesPath,
  ...
}:
{

  imports = [
    "${toString modulesPath}/profiles/qemu-guest.nix"
  ];

  options = { };

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

  };

}
