{ lib, ... }:
{
  imports = [
    ../modules/workstation.nix
    ../modules/users/josh.nix
    ../modules/containers.nix
  ];
  home-manager.users.josh.imports = [
    ../../home-manager/development.nix
    ../../home-manager/users/josh/workstation.nix
    ../../hm/gnupg.nix
  ];

  # wsl does not care for this
  networking.nftables.enable = lib.mkForce false;
}
