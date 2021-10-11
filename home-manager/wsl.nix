{pkgs, ...}:

{

  imports = [
    ./home.nix
    ./non-nixos.nix
    ./ssh-config.nix
    ./shell-environment.nix
    ./dev-tools.nix
  ];

}

