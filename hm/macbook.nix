{config, pkgs, ...}:

{

  imports = [
    ./home.nix
    ./shell-environment.nix
    ./gui-environment.nix
  ];

  xresources.properties = {
    "Xft.dpi" = 140;
    "Rofi.dpi" = 140;
  };
}

