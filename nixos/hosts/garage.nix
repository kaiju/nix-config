{ pkgs, ... }:
{
  imports = [
    ../modules/base.nix
    ../modules/workstation.nix
    ../modules/xorg.nix
    ../modules/containers.nix
    ../modules/audio.nix
    ../modules/users/josh.nix
  ];

  home-manager.users.josh.imports = [
    ../../hm/obsidian.nix
    ../../hm/gaming.nix
    ../../hm/dev-tools.nix
    ../../hm/xorg.nix
    ../../hm/wayland.nix
    ../../hm/gui-environment.nix
    ../../hm/comms.nix
    ../../hm/gnupg.nix
    ../../hm/rbw.nix
    ../../hm/neovim.nix
    ../../hm/sublime-text.nix
    ../../hm/obsidian.nix
  ];

  networking.hostName = "garage";
  mast.wallpaper = "${pkgs.mastpkgs.wallpaper}/lucas-k-wQLAGv4_OYs-unsplash.jpg";

  # most of this should probably be moved to gui or whatever
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

}
