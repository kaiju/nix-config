{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    sublime4
    nodejs  # LSP-pyright wants nodejs, we give it nodejs
  ];

  home.file.LSP-settings = {
    target = ".config/sublime-text/Packages/User/LSP.sublime-settings";
    text = ''
    {
      "lsp_format_on_save": true,
      "lsp_code_actions_on_save": {
        "source.fixAll": false,
        "source.organizeImports": true
      }
    }
    '';
  };

  # Set up LSP-ruff settings to use ruff out of the nix store, since
  # sublime-lsp is annoying and wants to download/manage all it's own language server dependencies
  home.file.LSP-ruff-settings = {
    target = ".config/sublime-text/Packages/User/LSP-ruff.sublime-settings";
    text = ''
    {
      "command": [
        "${pkgs.ruff}/bin/ruff",
        "server"
      ]
    }
    '';
  };

  home.file.LSP-pyright-settings = {
    target = ".config/sublime-text/Packages/User/LSP-pyright.sublime-settings";
    text = ''
    {
      "settings": {
        "pyright.disableOrganizeImports": true
      }
    }
    '';
  };

  # Same with gopls
  home.file.LSP-gopls-settings = {
    target = ".config/sublime-text/Packages/User/LSP-gopls.sublime-settings";
    text = ''
    {
      "settings": {
        "manageGoplsBinary": false
      },
      "command": [
        "${pkgs.gopls}/bin/gopls"
      ]
    }
    '';
  };

  # TODO -- dump out some initial config
}
