{ ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" ];
    mutableUserSettings = true; # for now
  };
}
