{ config, ... }:
{

  users.users.sky = {
    uid = 1001;
    isNormalUser = true;
    extraGroups = [ "mast" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7CifyuD7p/qSi61K5MQ38ib6V1pUVFQh4eC2IrS++3 josh@aether"
    ];
  };

  home-manager.users.sky = {
    home.username = "sky";
    home.homeDirectory = "/home/sky";
    home.stateVersion = config.system.stateVersion;
  };

}
