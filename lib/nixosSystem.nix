{ nixpkgs, home-manager }:
# consider putting stateVersion w/ a default in here
{ host, system, hardware, modules ? [] }:
let
  overlays = import ../overlays.nix { pkgs = nixpkgs.legacyPackages.${system}; };
in
nixpkgs.lib.nixosSystem {
  inherit system;

  modules = modules ++ [
    hardware
    home-manager.nixosModule
    overlays
    ../hosts/${host}.nix
  ];
}

