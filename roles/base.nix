{ config, pkgs, ... }:
{

  time.timeZone = "America/New_York";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config.allowUnfree = true;

  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    exa
    tmux
    htop
    ranger
    wget
    curl
    git
    file
    lm_sensors
    dnsutils
    usbutils
    nix-tree
  ];

  programs.zsh.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

}
