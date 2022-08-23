{ lib, config, pkgs, ... }:
{

  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "users" "wheel" "networkmanager" "docker" "video" "plugdev" "audio" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [
      ../files/josh.pubkey
    ];
  };

  home-manager.users.josh = {

    imports = [
      ../home-manager/shell-environment.nix
      ../home-manager/neovim.nix
    ];

    home.username = "josh";
    home.homeDirectory = "/home/josh";
    home.stateVersion = config.system.stateVersion;
  };

}
