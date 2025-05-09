{ lib, config, pkgs, ... }:
{

  nix.settings.trusted-users = [ "josh" ];

  users.users.josh = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "mast" "users" "wheel" "networkmanager" "docker" "video" "plugdev" "audio" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADwZpb0PKtHjAPMMTLTPfS1R1pfpCXSaVllJqM5Y9E8 josh@mast.zone"
    ];
  };

  home-manager.users.josh = {

    home.stateVersion = config.system.stateVersion;

    imports = [
      ../../hm/josh.nix
    ];

  };
}
