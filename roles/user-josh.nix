{ lib, config, pkgs, ... }:
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
  };
in {
  imports = [
    ("${home-manager}/nixos")
  ];

  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "users" "wheel" "networkmanager" "docker" "video" ];
    shell = pkgs.zsh;
  };

  home-manager.users.josh = {

    imports = [
      ../home-manager/shell-environment.nix
    ];

    home.username = "josh";
    home.homeDirectory = "/home/josh";
    home.stateVersion = config.system.stateVersion;
  };

ix}
