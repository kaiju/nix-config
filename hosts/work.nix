{ ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/efi-boot.nix
    ../roles/vmware-guest.nix
    ../roles/user-josh.nix
    ../roles/xorg.nix
  ];
  home-manager.users.josh.imports = [
    ../home-manager/dev-tools.nix
    ../home-manager/neovim.nix
    ../home-manager/ssh-config.nix
    ../home-manager/xorg.nix
    ../home-manager/gui-environment.nix
    ../home-manager/gnupg.nix
  ];
  system.stateVersion = "21.11";
  services.xserver.xkbOptions = "altwin:swap_alt_win";
  networking.hostName = "werk";
}
