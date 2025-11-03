{
  lib,
  config,
  pkgs,
  ...
}:
{

  imports = [
    ./observability.nix
  ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = lib.mkDefault false;
      };
    };
  };

  security.pam.sshAgentAuth = {
    enable = true;
  };

}
