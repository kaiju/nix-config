{ lib, config, pkgs, ... }:
{

  users.users.sky = {
    uid = 1001;
    isNormalUser = true;
    extraGroups = [ "mast" ];
  };

  home-manager.users.sky = {
    home.username = "sky";
    home.homeDirectory = "/home/sky";
    home.stateVersion = config.system.stateVersion;
  };

}
