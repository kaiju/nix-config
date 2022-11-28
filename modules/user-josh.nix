{ lib, config, pkgs, ... }:
{

  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "users" "wheel" "networkmanager" "docker" "video" "plugdev" "audio" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADwZpb0PKtHjAPMMTLTPfS1R1pfpCXSaVllJqM5Y9E8 josh@mast.zone"
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
