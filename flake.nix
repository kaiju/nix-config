{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

  };

  outputs = { self, nixpkgs, flake-utils, nixos-hardware, home-manager }@inputs:
  let

    # Pull in my overlays -- can remove this with custom system creating functions
    overlays = import ./overlays.nix; 

    # function to build nixos systems in a common way
    nixosSystem = import ./lib/nixosSystem.nix { inherit nixpkgs home-manager; };

    # TODO: functions to create various types of VMs

  in {

    nixosConfigurations.aether = nixosSystem {
      host = "aether"; # maybe rename to 'config'
      system = "x86_64-linux";
      hardware = ./hardware/thinkpad.nix; # rename to target? 
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
      ];
    };

    # garage workstation
    nixosConfigurations.garage = nixosSystem {
      host = "garage";
      system = "x86_64-linux";
      hardware = ./hardware/ugh.nix;
    };

    # sigint -- radio intelligence
    nixosConfigurations.sigint = nixosSystem {
      host = "sigint";
      system = "x86_64-linux";
      hardware = ./hardware/sigint.nix;
    };

    # shell host configuration
    nixosConfigurations.shell = nixosSystem {
      host = "shell";
      system = "x86_64-linux";
      hardware = ./hardware/qemu-guest.nix;
    };

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


    nixosConfigurations.k8s = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware/qemu-guest.nix
        overlays
        home-manager.nixosModule
        ./hosts/k8s.nix
      ];
    };

    # test vm
    nixosConfigurations.artemis = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware/qemu-guest.nix
        overlays
        home-manager.nixosModule
        ./hosts/artemis.nix
      ];
    };




    # mess-around virtualisation machine, 16 core xeon, 192GB
    nixosConfigurations.kronos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        overlays
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
        overlays
        home-manager.nixosModule
        ./hosts/mastzone.nix
      ];
    };

    nixosConfigurations.work = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        overlays
        home-manager.nixosModule
        ./hardware/vmware-guest.nix
        ./hosts/work.nix
      ];
    };

    nixosConfigurations.erebus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        overlays
        home-manager.nixosModule
        ./hardware/vmware-guest.nix
        ./hosts/erebus.nix
      ];
    };

  };
}
