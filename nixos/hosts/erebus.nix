{ ... }:
{
  imports = [
    ../modules/vmware-guest.nix
    ../modules/user-josh.nix
    ../modules/containers.nix
    ../modules/xorg.nix
  ];
  home-manager.users.josh.imports = [
    ../../hm/dev-tools.nix
    ../../hm/xorg.nix
    ../../hm/gui-environment.nix
    ../../hm/gnupg.nix
  ];
}
