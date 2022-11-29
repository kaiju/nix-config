{ ... }:
{
  home.packages = with pkgs; [
    colima
  ];

  home.shellAliases = {
    subl = "/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl -w ";
  };
}
