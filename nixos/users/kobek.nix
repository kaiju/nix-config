{ pkgs, ... }:
{
  users.users.kobek = {
    isNormalUser = true;
    extraGroups = [ "users" ];
    shell = pkgs.bash;
  };
}
