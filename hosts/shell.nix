{ config, pkgs, ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/server.nix
  ];

  system.stateVersion = "22.11";

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

  environment.systemPackages = with pkgs; [
    rtorrent
    youtube-dl
    beets
  ];

  # virtiofs filesystem mounts
  fileSystems.media = {
    device = "media";
    fsType = "virtiofs";
    mountPoint = "/media";
  };

  fileSystems.homes = {
    device = "homes";
    fsType = "virtiofs";
    mountPoint = "/homes";
  };

  # Common user settings
  users.groups.mast = {
    gid = 1002;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [
    ../home-manager/shell-environment.nix
    ../home-manager/neovim.nix
  ];

  # Josh
  users.users.josh = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "mast" "wheel" ];
    password = "";
  };

  home-manager.users.josh = {
    home.username = "josh";
    home.homeDirectory = "/home/josh";
    home.stateVersion = config.system.stateVersion;
    systemd.user.tmpfiles.rules = [
      "L /home/josh/files - - - - /homes/josh"
    ];
    programs.beets = {
      enable = true;
      settings = {
        directory = "/media/music";
        library = "/media/musiclibrary.db";
      };
    };
  };

  # Sky
  users.users.sky = {
    uid = 1001;
    isNormalUser = true;
    extraGroups = [ "mast" ];
  };

  home-manager.users.sky = {
    home.username = "sky";
    home.homeDirectory = "/home/sky";
    home.stateVersion = config.system.stateVersion;
    systemd.user.tmpfiles.rules = [
      "L /home/sky/files - - - - /homes/sky"
    ];
  };


  networking.firewall.allowedTCPPorts = [ 5357 ];
  networking.firewall.allowedUDPPorts = [ 3702 ];

  services.samba = {
    enable = true;
    openFirewall = true;
    extraConfig = ''
      min protocol = SMB2

      ea support = yes
      vfs objects = fruit streams_xattr
      fruit:metadata = stream
      fruit:model = MacSamba
      fruit:veto_appledouble = no
      fruit:posix_rename = yes
      fruit:zero_file_id = yes
      fruit:wipe_intentionally_left_blank_rfork = yes
      fruit:delete_empty_adfiles = yes

      [homes]
        comment = Home Directories
        browseable = no
        create mask = 0700
        directory mask = 0700
        valid users = %S
        path = %H/files
    '';
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
    enable = true;
  };

  services.plex = {
    enable = true;
    openFirewall = true;
  };

}
