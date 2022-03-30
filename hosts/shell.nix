{ config, pkgs, ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/efi-boot.nix
    ../roles/server.nix
  ];

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    interfaces = {
      ens3.useDHCP = false;
      ipv4.addresses = [
        { address = "192.168.8.15"; prefixLength = 21; }
      ];
    };
    hostName = "shell";
  };

  users.groups.mast = {
    gid = 1002;
  };

  users.users.sky = {
    uid = 1001;
    isNormalUser = true;
    extraGroups = [ "mast" ];
  };

  users.users.josh = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "mast" ];
  };

  environment.systemPackages = with pkgs; [
    rtorrent
  ];

  services.samba = {
    enable = true;
    openFirewall = true;
    samba-wsdd.enable = true;
    samba-wsdd.domain = "mast.haus";
    shares = {
      media = {
        comment = "Media";
        browseable = "yes";
        path = "/media";
        "guest ok" = "yes";
        "force group" = "mast";
        "read only" = "no";
        "read list" = "guest nobody";
        "create mask" = 0655;
      };
    };
  };

}
