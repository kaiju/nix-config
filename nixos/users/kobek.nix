{ pkgs, ... }:
{
  users.users.kobek = {
    uid = 1008;
    isNormalUser = true;
    extraGroups = [ "users" ];
    shell = pkgs.bash;
  };
}
