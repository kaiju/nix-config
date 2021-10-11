{pkgs, ...}:

{

  imports = [
    ./home.nix
    ./shell-environment.nix
    ./non-nixos.nix
    ./gui-environment.nix
  ];

  xresources.properties = {
    "*.dpi" = 96;
  };
}

