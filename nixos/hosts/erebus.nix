{ ... }:
{
  imports = [
    ../modules/workstation.nix
    ../modules/user-josh.nix
    ../modules/containers.nix
  ];
  home-manager.users.josh.imports = [
    ../../hm/dev-tools.nix
    ../../hm/gnupg.nix
  ];
}
