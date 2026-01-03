# Development tools
{ pkgs, ... }:
{

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        load_dotenv = true;
        strict_env = true;
      };
    };
  };

  programs.git = {
    enable = true;
    settings = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  home.packages = [
    pkgs.mastpkgs.plate
  ];

}
