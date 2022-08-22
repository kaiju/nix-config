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
    password = "";
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

  networking.firewall.allowedTCPPorts = [ 5357 ];
  networking.firewall.allowedUDPPorts = [ 3702 ];

  services.samba = {
    enable = true;
    openFirewall = true;
    extraConfig = ''
      netbios name = NEWFILES
      workgroup = WORKGROUP
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
    domain = "mast.haus";
  };

}
