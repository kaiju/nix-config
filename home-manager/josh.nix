{ ... }:
{
  home.stateVersion = "22.05"; # ternary this based off config
  home.username = "josh";
  home.homeDirectory = "/home/josh"; # ternary this based off builtins.system
  programs.home-manager.enable = true;
}
