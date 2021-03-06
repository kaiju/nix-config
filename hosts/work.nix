{ pkgs, ... }:
{
  imports = [
    ../roles/base.nix
    ../roles/vmware-guest.nix
    ../roles/user-josh.nix
    ../roles/containers.nix
    ../roles/xorg.nix
  ];
  home-manager.users.josh.imports = [
    ../home-manager/dev-tools.nix
    ../home-manager/ssh-config.nix
    ../home-manager/xorg.nix
    ../home-manager/gui-environment.nix
    ../home-manager/gnupg.nix
  ];
  
  system.stateVersion = "21.11";
  services.xserver.xkbOptions = "altwin:swap_alt_win";
  networking.hostName = "work";

  home-manager.users.josh = {
    # >:S
    programs.git.userName = pkgs.lib.mkOverride 10 "Josh Mast";
    programs.git.userEmail = pkgs.lib.mkOverride 10 "joshua.mast@puppet.com";
    programs.ssh.matchBlocks."github.com" = {
      user = "git";
      hostname = "github.com";
      identitiesOnly = true;
      identityFile = "/home/josh/.ssh/joshua.mast@puppet.com.pub.key";
    };
  };

}
