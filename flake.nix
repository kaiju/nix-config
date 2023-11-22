{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

  };

  outputs = { self, nixpkgs, flake-utils, nixos-hardware, home-manager, agenix }@inputs:
  let

    nixosSystem = import ./lib/nixosSystem.nix { inherit nixpkgs home-manager; };
    vmImage = import ./lib/vmImage.nix { inherit nixpkgs self; };

  in {

    # Lenovo Thinkpad X1 (7th Gen)
    nixosConfigurations.aether = nixosSystem {
      host = "aether";
      system = "x86_64-linux";
      hardware = ./hardware/thinkpad_x1.nix;
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
      ];
    };

    # new linux workstation for futzing with ml
    nixosConfigurations.arcimedes = nixosSystem {
    	host = "arcimedes";
	system = "x86_64-linux";
	hardware = ./hardware/efi-boot.nix;
	modules = [
	  ./modules/user-josh.nix

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

    nixosConfigurations.torrent = nixosSystem {
      host = "torrent";
      system = "x86_64-linux";
      hardware = ./hardware/qemu-guest.nix;
      modules = [
        ./modules/server.nix
        ./modules/user-josh.nix
      ];
    };

    nixosConfigurations.ops = nixosSystem {
      host = "ops";
      system = "x86_64-linux";
      hardware = ./hardware/qemu-guest.nix;
      modules = [
        ./modules/server.nix
        ./modules/user-josh.nix
      ];
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
      system = "aarch64-linux";
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

    */
    homeConfigurations.macbook = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [
        {
          home.homeDirectory = nixpkgs.lib.mkOverride 10 "/Users/josh";
          home.sessionPath = [
            "$HOME/.rd/bin"
          ];
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
    build-vm = vmImage {
      nixosConfiguration = self.nixosConfigurations.artemis;
    };

    devShell.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      packages = with nixpkgs.legacyPackages.x86_64-linux; [
        python311
        openssh
        rage
        jq
      ];
    };

  }; 
}

