{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" ];
    mutableUserSettings = true; # for now
    extraPackages = with pkgs; [
      nixd
      nil
    ];
  };
}
