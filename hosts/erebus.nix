{ ... }:
{
  imports = [
    ../modules/vmware-guest.nix
    ../modules/user-josh.nix
    ../modules/containers.nix
    ../modules/xorg.nix
  ];
  home-manager.users.josh.imports = [
    ../home-manager/dev-tools.nix
    ../home-manager/xorg.nix
    ../home-manager/gui-environment.nix
    ../home-manager/gnupg.nix
  ];
}
