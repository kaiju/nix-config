{ lib, config, pkgs, ... }:
{

  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "users" "wheel" "networkmanager" "docker" "video" "plugdev" ];
    shell = pkgs.zsh;
  };

  home-manager.useUserPackages = true;
  home-manager.users.josh = {

    imports = [
      ../home-manager/shell-environment.nix
    ];

    nixpkgs.config.allowUnfree = true;

    home.username = "josh";
    home.homeDirectory = "/home/josh";
    home.stateVersion = config.system.stateVersion;
  };

}
