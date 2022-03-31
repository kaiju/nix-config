{ config, pkgs, ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/server.nix
  ];

  networking = {
    useDHCP = false;
    defaultGateway = {
      address = "192.168.8.1";
      interface = "eth0";
    };
    nameservers = [
      "192.168.8.1"
    ];
    interfaces = {
      eth0 = {
        useDHCP = false;
        ipv4.addresses = [
          { address = "192.168.8.15"; prefixLength = 21; }
        ];
      };
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
    extraGroups = [ "mast" "wheel" ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [
    ../home-manager/shell-environment.nix
    ../home-manager/neovim.nix
  ];

  home-manager.users.josh = {
    home.username = "josh";
    home.homeDirectory = "/home/josh";
    home.stateVersion = config.system.stateVersion;
  };

  environment.systemPackages = with pkgs; [
    rtorrent
  ];

  networking.firewall.allowedTCPPorts = [ 5357 ];
  networking.firewall.allowedUDPPorts = [ 3702 ];

  services.samba = {
    enable = false;
    openFirewall = true;
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

  services.samba-wsdd = {
    enable = false;
    domain = "mast.haus";
  };

}
