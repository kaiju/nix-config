{ pkgs, ... }:
{
  imports = [
    ../modules/vmware-guest.nix
    ../modules/user-josh.nix
    ../modules/containers.nix
    ../modules/xorg.nix
  ];
  home-manager.users.josh.imports = [
    ../../hm/dev-tools.nix
    ../../hm/xorg.nix
    ../../hm/gui-environment.nix
    ../../hm/gnupg.nix
  ];
  
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
