{ lib, config, pkgs, ... }:
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
  };
  modules = config.homeManagerModules;
in {
  imports = [
    ("${home-manager}/nixos")
  ];

  # create an option that should allow us to set a list of paths to import into home-manager
  options = {
    homeManagerModules = lib.mkOption {
      type = lib.types.listOf (lib.types.path);
      default = [ ];
    };
  };

  config = {

    users.users.josh = {
      isNormalUser = true;
      extraGroups = [ "users" "wheel" "networkmanager" "docker" "video" ];
      shell = pkgs.zsh;
    };

    home-manager.users.josh = {
      #imports = modules;
      #imports = [
      #  ../home-manager/shell-environment.nix
      #];
      home.username = "josh";
      home.homeDirectory = "/home/josh";
      home.stateVersion = config.system.stateVersion;
    };

  };

}
