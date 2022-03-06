{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    my-pkgs.url = "path:./packages";

  };

  outputs = { self, nixpkgs, nixos-hardware, my-pkgs, home-manager }@inputs:
  let
    my-overlays = {
      nixpkgs.overlays = [
        my-pkgs.overlays.wallpaper
        my-pkgs.overlays.ble-thermometer-scan
      ];
    };
  in {

    # aether - Lenovo Thinkpad X1 (7th Gen)
    nixosConfigurations.aether = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { nixpkgs.config.permittedInsecurePackages = [ "electron-13.6.9" ]; }
        my-overlays
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
        home-manager.nixosModule
        ./hardware/thinkpad.nix
        ./hosts/thinkpad.nix
      ];
    };

    nixosConfigurations.work = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        my-overlays
        home-manager.nixosModule
        ./hardware/vmware-guest.nix
        ./hosts/work.nix
      ];
    };

    nixosConfigurations.erebus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        my-overlays
        home-manager.nixosModule
        ./hardware/vmware-guest.nix
        ./hosts/erebus.nix
      ];
    };

    nixosConfigurations.sigint = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        my-overlays
        home-manager.nixosModule
        ./hardware/sigint.nix
        ./hosts/sigint.nix
      ];
    };

  };
}
