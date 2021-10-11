{ config, pkgs, ... }:
{
  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "users" "wheel" "networkmanager" "docker" "video" ];
    shell = pkgs.zsh;
  };

  # TODO -- figure out how to do multiple home manager configs across hosts
  # home-manager.users.josh = {
}
