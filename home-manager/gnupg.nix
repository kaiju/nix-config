{ config, pkgs, ... }:
{

  # override pinentry so we don't build a bunch of X11 garbage
  # https://github.com/NixOS/nixpkgs/issues/124753
  nixpkgs.overlays = [
    (self: super: {
      pinentry = super.pinentry.override {
        enabledFlavors = [ "curses" ];
      };
    })
  ];

  home.packages = with pkgs; [
    gnupg
  ];

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "curses";
  };
}
