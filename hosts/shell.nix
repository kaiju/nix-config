{ config, pkgs, ... }:
{
  imports = [
    ../modules/server.nix
    ../modules/user-josh.nix
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

  services.transmission = {
    enable = true;
    group = "mast";
    settings = {
      download-dir = "/shares/shared/torrent_downloads";
      incomplete-dir = "/shares/shared/torrent_downloads/incomplete";
      watch-dir-enabled = true;
      watch-dir = "/shares/shared/torrent_files";
      rpc-bind-address = "0.0.0.0";
      rpc-host-whitelist-enabled = false;
      rpc-whitelist = "192.168.8.*,192.168.9.*,192.168.10.*,192.168.11.*";
    };
    openFirewall = true;
    openRPCPort = true;
    openPeerPorts = true;
  };

  environment.systemPackages = with pkgs; [
    rtorrent
    youtube-dl
    beets
  ];

  # virtiofs filesystem mounts
  fileSystems.shares = {
    device = "shares";
    fsType = "virtiofs";
    mountPoint = "/shares";
  };

  # Common user settings
  # should dump this in base
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
  users.users.josh.extraGroups = [ "mast" "wheel" ];

  home-manager.users.josh = {
    systemd.user.tmpfiles.rules = [
      "L /home/josh/files - - - - /shares/josh"
    ];
    programs.beets = {
      enable = true;
      settings = {
        directory = "/shares/media/music";
        library = "/shares/media/musiclibrary.db";
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
      "L /home/sky/files - - - - /shares/sky"
    ];
  };


  # Neccessary for samba-wsdd
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
        comment = User shares 
        browseable = no
        create mask = 0700
        directory mask = 0700
        valid users = %S
        path = /shares/%S
        read only = no
        force group = mast
    '';
    shares = {
      shared = {
        comment = "Shared files";
        browseable = "yes";
        path = "/shares/shared";
        "force group" = "mast";
        "read only" = "no";
        "create mask" = 0655;
        "valid users" = "josh sky";
      };
      media = {
        comment = "Media";
        browseable = "yes";
        path = "/shares/media";
        "force group" = "mast";
        "read only" = "no";
        "read list" = "guest nobody";
        "create mask" = 0655;
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    hostname = "FILES";
  };

  services.plex = {
    enable = true;
    openFirewall = true;
  };

}
