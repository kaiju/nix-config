{ ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/vmware-guest.nix
    ../roles/user-josh.nix
    ../roles/containers.nix
    ../roles/xorg.nix
  ];
  home-manager.users.josh.imports = [
    ../home-manager/dev-tools.nix
    ../home-manager/ssh-config.nix
    ../home-manager/xorg.nix
    ../home-manager/gui-environment.nix
    ../home-manager/gnupg.nix
  ];
  system.stateVersion = "21.11";
  networking.hostName = "erebus";
}
