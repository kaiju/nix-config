{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    my-pkgs = {
      url = "path:./packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixos-hardware, my-pkgs, home-manager }@inputs:
  let

    my-overlays = {
      # just mash in all of my packages from my-pkgs in as overlays
      nixpkgs.overlays = nixpkgs.lib.attrValues my-pkgs.overlays;
    };

  in {

    # build a lxc container image from shell system config
    # nix build '.#shell-container' builds a rootfs tarball and metadata
    # neccessary for importing into lxc
    shell-container = nixpkgs.legacyPackages.x86_64-linux.stdenv.mkDerivation {
      name = "shell-container";
      src = self;
      installPhase = ''
        mkdir -p $out
        ln -s "${self.nixosConfigurations.shell.config.system.build.tarball}/tarball/nixos-system-x86_64-linux.tar.xz" $out/nixos-rootfs.tar.xz
        ln -s "${self.nixosConfigurations.shell.config.system.build.metadata}/tarball/nixos-system-x86_64-linux.tar.xz" $out/nixos-metadata.tar.xz
      '';
    };

    # shell host configuration
    nixosConfigurations.shell = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/virtualisation/lxc-container.nix"
        my-overlays
        home-manager.nixosModule
        ./hosts/shell.nix
      ];
    };

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

    nixosConfigurations.kronos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        my-overlays
        home-manager.nixosModule
        ./hardware/efi-boot.nix
        ./hosts/kronos.nix
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
