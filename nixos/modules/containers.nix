{ pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      extraPackages = with pkgs; [
        podman-compose
      ];
    };
  };
}
