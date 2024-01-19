{ nixpkgs, home-manager }:
{ system, modules ? [] }:
home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.${system};
  modules = modules ++ [
    {
      nixpkgs.overlays = import ./overlays.nix; # pull in overlays
    }
    ../home-manager/josh.nix
    ../home-manager/shell-environment.nix
    ../home-manager/neovim.nix
  ];
}
