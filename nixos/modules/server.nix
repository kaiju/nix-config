{ lib, config, pkgs, ... }:
{

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
    prometheus.exporters = {
      node = {
        enable = true;
        openFirewall = true;
      };
    };
  };

  security.pam.sshAgentAuth = {
    enable = true;
  };

}
