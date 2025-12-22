{ lib, pkgs, ... }:
{

  imports = [
    ../modules/server.nix
    ../users/josh.nix
  ];

  image.modules.lxc-incus = {

    virtualisation.lxc.templates = {

      "hostname" = {
        enable = true;
        target = "/etc/hostname";
        template = pkgs.writeTextFile {
          name = "hostname.tpl";
          text = "{{ container.name }}";
        };
        when = [ "create" ];
      };

    };

  };

  networking = {
    hostName = lib.mkForce "";
    useDHCP = true;
  };

}
