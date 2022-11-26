/* This function returns a function that will create nixpkgs.lib.nixosSystem configurations in a common
   pattern */
{ nixpkgs, home-manager }:
{ host, system, hardware, modules ? [] }:
nixpkgs.lib.nixosSystem {
  inherit system;

  /*
    Open Question -- what passes pkgs, config, and all those other attrset attributes in?

    Answer: They're passed in as a matter of being a function that's passed into
    nixpkgs.lib.nixosSystem.modules, or via a NixOS module's `imports`. Confusing
    implicit behavior!
  */

  /* Pull in our common modules, along with any additional modules specified via
     the `modules` attribute */
  modules = modules ++ [
    {
      # Set hostname
      networking.hostName = host;
    }

    hardware

    # Add home-manager w/ our default configuration settings
    home-manager.nixosModule {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }

    # Pull in our base config
    ../roles/base.nix

    # Add our overlays from overlays.nix
    #overlays
    ../modules/overlays.nix

    # and finally, host-specific configuration
    ../hosts/${host}.nix
  ];
}

