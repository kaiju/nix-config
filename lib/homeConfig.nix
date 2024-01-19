{ nixpkgs, home-manager }:
{ system, modules ? [] }:
home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.${system};
  modules = modules ++ [
    {
      nixpkgs.overlays = import ./overlays.nix; # pull in overlays
    }
    ../hm/josh.nix
    ../hm/shell-environment.nix
    ../hm/neovim.nix
  ];
}
