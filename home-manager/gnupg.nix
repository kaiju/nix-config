{
  home.sessionVariables = {
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
}
