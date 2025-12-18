{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../modules/server.nix
    ../users/josh.nix
  ];

  # ZFS configuration
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "tank" ];
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
  '';
  services.zfs.autoScrub.enable = true;

  # Networking
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking = {
    hostName = "kronos";
    hostId = "00dddef1";
    useDHCP = false;
    defaultGateway = "192.168.8.1";
    nameservers = [ "192.168.8.1" ];

    nat = {
      enable = true;
      externalInterface = "br0";
      internalInterfaces = [
        "internalbr0"
      ];
    };

    interfaces.internal0 = {
      virtual = true;
      virtualOwner = "root";
      virtualType = "tap";
    };

    interfaces.internalbr0 = {
      ipv4.addresses = [
        {
          address = "10.10.10.1";
          prefixLength = 24;
        }
      ];
    };

    interfaces.br0 = {
      ipv4.addresses = [
        {
          address = "192.168.8.44";
          prefixLength = 22;
        }
      ];
    };

    bridges = {
      internalbr0.interfaces = [ "internal0" ];
      br0.interfaces = [ "enp1s0f0" ];
    };

  };

  # Libvirt
  security.polkit.enable = true; # can't virsh as libvirtd group user w/o this
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [
      "internalbr0"
      "br0"
    ];
    qemu.ovmf.enable = true;
  };
  # Prevent default libvirt network from getting created and autostarted
  # https://github.com/NixOS/nixpkgs/issues/73418#issuecomment-883701022
  systemd.services.libvirtd-config.script = lib.mkAfter ''
    rm /var/lib/libvirt/qemu/networks/default.xml
    rm /var/lib/libvirt/qemu/networks/autostart/default.xml
  '';
  environment.systemPackages = with pkgs; [
    virtiofsd
  ];

  users.users.josh.extraGroups = [ "libvirtd" ];
  home-manager.users.josh.home.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";

}
