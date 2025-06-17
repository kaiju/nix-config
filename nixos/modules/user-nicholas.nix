{ lib, config, pkgs, ... }:
{

  users.users.nicholas = {
    uid = 1002;
    isNormalUser = true;
    extraGroups = [ "mast" ];
  };

  home-manager.users.nicholas = {
    home.username = "nicholas";
    home.homeDirectory = "/home/nicholas";
    home.stateVersion = config.system.stateVersion;
  };

}
