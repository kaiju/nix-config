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

    # function to build nixos systems in a common pattern 
    nixosSystem = import ./lib/nixosSystem.nix { inherit nixpkgs home-manager; };

    # TODO: functions to create various types of VM images

  in {

    # Lenovo Thinkpad X1 (7th Gen)
    nixosConfigurations.aether = nixosSystem {
      host = "aether";
      system = "x86_64-linux";
      hardware = ./hardware/thinkpad.nix; # rename to target? 
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
      ];
    };

    # oracle cloud a1 vm
    nixosConfigurations.armitage = nixosSystem {
      host = "armitage";
      system = "aarch64-linux";
      hardware = ./hardware/oci.nix;
      modules = [
        ./modules/user-josh.nix
        ./modules/server.nix
      ];
    };

    # Cobbled together i7-3770 workstation in the garage 
    nixosConfigurations.garage = nixosSystem {
      host = "garage";
      system = "x86_64-linux";
      hardware = ./hardware/ugh.nix;
    };

    # VPS
    nixosConfigurations.mastzone = nixosSystem {
      host = "mastzone";
      system = "x86_64-linux";
      hardware = ./hardware/vps2day.nix;
    };

    # sigint -- radio intelligence
    nixosConfigurations.sigint = nixosSystem {
      host = "sigint";
      system = "x86_64-linux";
      hardware = ./hardware/sigint.nix;
    };

    # mess-around lab virtualisation machine, 16 core xeon, 192GB ram
    nixosConfigurations.kronos = nixosSystem {
      host = "kronos";
      system = "x86_64-linux";
      hardware = ./hardware/efi-boot.nix;
    };

    # shell host vm configuration
    nixosConfigurations.shell = nixosSystem {
      host = "shell";
      system = "x86_64-linux";
      hardware = ./hardware/qemu-guest.nix;
    };

    # home k8s vm instance using k3s
    nixosConfigurations.k8s = nixosSystem {
      host = "k8s";
      system = "x86_64-linux";
      hardware = ./hardware/qemu-guest.nix;
    };

    # testing/playground vm
    nixosConfigurations.artemis = nixosSystem {
      host = "artemis";
      system = "x86_64-linux";
      hardware = ./hardware/qemu-guest.nix;
      modules = [
        ./modules/server.nix
        ./modules/user-josh.nix
      ];
    };

    # old work VM
    nixosConfigurations.work = nixosSystem {
      host = "work";
      system = "x86_64-linux";
      hardware = ./hardware/vmware-guest.nix;
    };
      
    # old vmware desktop VM
    nixosConfigurations.erebus = nixosSystem {
      host = "erebus";
      system = "x86_64-linux";
      hardware = ./hardware/vmware-guest.nix;
    };

    /* Surprise! It turns out you can also include Home Manager configurations as
       flake outputs! https://nix-community.github.io/home-manager/index.html#sec-flakes-standalone

       This is useful for providing my home configurations in non-NixOS contexts, like
       my work laptop, WSL2, etc where previously I was setting up a separate ~/.config/nixpkgs/home.nix
       file.

       WIP TODO:
        - Figure out how best to manage multiple architectures
        - Write function to barf out a common configuration across different systems 
    */
    homeConfigurations.macbook = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [
        {
          home.homeDirectory = nixpkgs.lib.mkOverride 10 "/Users/josh";
        }
        home-manager/josh.nix
        home-manager/work.nix
        home-manager/darwin.nix
        home-manager/shell-environment.nix
        home-manager/neovim.nix
        home-manager/dev-tools.nix
      ];
    };

    homeConfigurations.wsl = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        home-manager/josh.nix
        home-manager/shell-environment.nix
        home-manager/neovim.nix
      ];
    };

    /*
     * EXPERIMENTAL STUFF
     */
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
  };
}

