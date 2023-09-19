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

    {
      nixpkgs.config.permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    }

    # Target hardware configuration
    hardware

    # Add home-manager w/ our default configuration settings
    home-manager.nixosModule {

      /* This makes home-manager use the same nixpkgs instance used by the
         rest of our NixOS configuration. This is particularly helpful since
         we build our home configuration via the NixOS module and apply it
         along with the rest of the system via nixos-rebuild. This also prevents
         some confusion since we only have to apply overlays to a single nixpkgs
         instance. */
      home-manager.useGlobalPkgs = true;

      home-manager.useUserPackages = true;
    }

    # Pull in our base config common to all systems
    ../modules/base.nix

    # Add our nixpkgs overlays from overlays.nix
    ../modules/overlays.nix

    # and finally, our host-specific configuration
    ../hosts/${host}.nix
  ];
}

