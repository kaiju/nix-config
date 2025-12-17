{ pkgs, ... }:
{

  imports = [
    ../modules/server.nix
    ../modules/users/josh.nix
  ];

  environment.systemPackages = with pkgs; [
    cowsay
  ];

  networking = {
    useDHCP = true;
    hostName = "artemis";
    domain = "mast.haus";
    firewall.trustedInterfaces = [
      "eth0"
    ];
  };

}
