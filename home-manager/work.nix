{ pkgs, ... }:
{
  programs.git.userEmail = pkgs.lib.mkOverride 10 "josh@fulcradynamics.com";
  programs.git.userName = pkgs.lib.mkOverride 10 "Josh Mast";
}
