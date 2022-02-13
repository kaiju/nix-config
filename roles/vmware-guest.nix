{ config, pkgs, ... }:
{
  imports = [
    ./xorg.nix # wayland under vmware still isn't there yet
  ];

  # Enable VMWare guest additions
  virtualisation.vmware.guest.enable = true;

  networking.interfaces.ens33.useDHCP = true;
  networking.firewall.enable = false;

  # Since we're running in VM on OSX, swap around our goofy keyboard setup
  services.xserver.xkbOptions = "altwin:swap_alt_win";

  # No passwords, no problems
  security.sudo.wheelNeedsPassword = false;

  # Thanks for the tip, Mitchell
  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
      "umask=22"
      "uid=1000"
      "gid=1000"
      "allow_other"
      "auto_unmount"
      "defaults"
    ];
  };

}
