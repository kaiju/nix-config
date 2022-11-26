{ nixpkgs, home-manager }:
{ host, system, hardware, modules ? [] }:
let
  # open question -- what passes pkgs, config, etc here? is it an aspect of `import` ?
  # durrr -- any function that gets passed into nixpkgs.lib.nixosSystem.modules
  # gets treated as a NixOS Module, i.e. it gets pkgs, config, etc passed in as an
  # attrset
  overlays = import ../overlays.nix;
in
nixpkgs.lib.nixosSystem {
  inherit system;

  /* something to consider here is whether we want to define too much of a base
     system here, vs. just pulling in a single module */
  modules = modules ++ [
    # Should this go into roles/base.nix? Or maybe we just import that
    # in here directly?
    {
      # Set a common stateVersion across all systems
      system.stateVersion = "22.05";

      # Set hostname
      networking.hostName = host;
    }

    hardware

    ../roles/base.nix

    home-manager.nixosModule {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      # bet I could pull in some home-manager defaults for my user here
    }

    overlays
    ../hosts/${host}.nix
  ];
}

