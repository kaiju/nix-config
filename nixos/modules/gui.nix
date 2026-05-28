/*
  Profile: GUI

  Common configuration between xorg/wayland
*/
{ pkgs, ... }:
{

  programs.dconf.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.cage}/bin/cage -s -d -- ${pkgs.foot}/bin/foot -f monospace:size=25 ${pkgs.tuigreet}/bin/tuigreet -s ${pkgs.sway}/share/wayland-sessions -t -r";
    };
  };
  #
  # Move these into a common module
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

}
