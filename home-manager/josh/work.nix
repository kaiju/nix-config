{ pkgs, ... }:
{
  programs.git.settings.user = {
    email = pkgs.lib.mkOverride 10 "josh@fulcradynamics.com";
    name = pkgs.lib.mkOverride 10 "Josh Mast";
  };
}
