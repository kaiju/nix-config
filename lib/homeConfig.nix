/* This function returns a function that will create nixpkgs.lib.nixosSystem configurations in a common
   pattern */
{ nixpkgs, home-manager }:
{ system, modules ? [] }:
home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.${system};
  modules = modules ++ [
    {
      nixpkgs.overlays = [
        (final: prev: {
          mastpkgs = prev.callPackage ../mastpkgs {};
          })
        ];
    }
  ];
}
