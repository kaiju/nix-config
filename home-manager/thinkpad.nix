{pkgs, ...}:

{

  imports = [
    ./home.nix
    ./shell-environment.nix
    ./ssh-config.nix
    ./gui-environment.nix
    ./dev-tools.nix
  ];

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
    MOZ_ENABLE_WAYLAND = 1;
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

}

