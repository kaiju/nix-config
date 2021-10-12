{ config, pkgs, ... }:
{

  time.timeZone = "America/New_York";
  nixpkgs.config.allowUnfree = true;

  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    vim
    exa
    tmux
    htop
    ranger
    wget
    curl
    git
    file
    lm_sensors
  ];

  programs.zsh.enable = true;
  programs.vim.defaultEditor = true;

}
