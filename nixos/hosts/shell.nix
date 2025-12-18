{ pkgs, ... }:
{
  imports = [
    ../modules/server.nix
    ../users/josh.nix
    ../users/sky.nix
    ../users/nicholas.nix
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
          {
            address = "192.168.8.15";
            prefixLength = 22;
          }
        ];
      };
    };
    hostName = "shell";
  };

  environment.systemPackages = with pkgs; [
    yt-dlp
    beets
  ];

  # virtiofs filesystem mounts
  fileSystems.shares = {
    device = "shares";
    fsType = "virtiofs";
    mountPoint = "/shares";
  };

  home-manager.sharedModules = [
    ../../home-manager/shell-environment.nix
    ../../home-manager/neovim.nix
  ];

  # Josh
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
  home-manager.users.sky = {
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
    settings = {

      global = {
        "invalid users" = [ "root" ];
        "passwd program" = "/run/wrapper/bin/passwd %s";
        "security" = "user";
        "min protocol" = "SMB2";
        "ea support" = "yes";
        "vfs objects" = [
          "fruit"
          "streams_xattr"
        ];
        "fruit:metadata" = "stream";
        "fruit:model" = "MacSamba";
        "fruit:veto_appledouble" = "no";
        "fruit:posix_rename" = "yes";
        "fruit:zero_file_id" = "yes";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
      };
      homes = {
        "comment" = "User shares";
        "browseable" = "no";
        "create mask" = "0700";
        "directory mask" = "0700";
        "valid users" = "%S";
        "path" = "/shares/%S";
        "read only" = "no";
        "force group" = "mast";
      };

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

}
