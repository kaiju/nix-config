{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    my-pkgs = {
      url = "path:./packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, agenix, nixos-hardware, my-pkgs, home-manager }@inputs:
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

    # example qemu guest vm
    # build a disk image with
    # nix build '.#vm.config.system.build.rawimage' or
    # nix build '.#vm.config.system.build.qcowimage'
    # nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   modules = [
    #     ./hardware/qemu-guest.nix
    #     my-overlays
    #     home-manager.nixosModule
    #     ./hosts/<host config>.nix
    #   ];
    # };

    # shell host configuration
    nixosConfigurations.shell = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware/qemu-guest.nix
        my-overlays
        home-manager.nixosModule
        ./hosts/shell.nix
      ];
    };

    nixosConfigurations.k8s = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware/qemu-guest.nix
        my-overlays
        home-manager.nixosModule
        ./hosts/k8s.nix
      ];
    };

    # test vm
    nixosConfigurations.artemis = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware/qemu-guest.nix
        my-overlays
        home-manager.nixosModule
        ./hosts/artemis.nix
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
        agenix.nixosModule
        ./hardware/thinkpad.nix
        ./hosts/thinkpad.nix
      ];
    };

    # mess-around virtualisation machine, 16 core xeon, 192GB
    nixosConfigurations.kronos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        my-overlays
        home-manager.nixosModule
        ./hardware/efi-boot.nix
        ./hosts/kronos.nix
      ];
    };

    # VPS
    nixosConfigurations.mastzone = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        ./hardware/vps2day.nix
        my-overlays
        home-manager.nixosModule
        ./hosts/mastzone.nix
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
