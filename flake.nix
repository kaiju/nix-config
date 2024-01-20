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

    nixosSystem = import lib/nixosSystem.nix { inherit nixpkgs home-manager; };
    homeConfig = import lib/homeConfig.nix { inherit nixpkgs home-manager; };
    vmImage = import lib/vmImage.nix { inherit nixpkgs self; };

  in {

    # Lenovo Thinkpad X1 (7th Gen)
    nixosConfigurations.aether = nixosSystem {
      host = "aether";
      system = "x86_64-linux";
      hardware = nixos/targets/thinkpad_x1.nix;
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
        nixos/modules/workstation.nix
        nixos/modules/laptop.nix
        nixos/modules/user-josh.nix
      ];
    };

    nixosConfigurations.x220 = nixosSystem {
      host = "x220";
      system = "x86_64-linux";
      hardware = ./nixos/targets/thinkpad_x220.nix;
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x220
        ./nixos/modules/workstation.nix
        ./nixos/modules/laptop.nix
        ./nixos/modules/user-josh.nix
      ];
    };

    # new linux workstation for futzing with ml
    nixosConfigurations.arcimedes = nixosSystem {
      host = "arcimedes";
      system = "x86_64-linux";
      hardware = ./nixos/targets/efi-boot.nix;
      modules = [
        ./nixos/modules/user-josh.nix
      ];
    };

    # oracle cloud a1 vm
    nixosConfigurations.armitage = nixosSystem {
      host = "armitage";
      system = "aarch64-linux";
      hardware = ./nixos/hardware/oci.nix;
      modules = [
        ./nixos/modules/server.nix
        ./nixos/modules/user-josh.nix
      ];
    };

    # Cobbled together i7-3770 workstation in the garage 
    nixosConfigurations.garage = nixosSystem {
      host = "garage";
      system = "x86_64-linux";
      hardware = ./nixos/targets/ugh.nix;
    };

    # VPS
    nixosConfigurations.mastzone = nixosSystem {
      host = "mastzone";
      system = "x86_64-linux";
      hardware = ./nixos/targets/vps2day.nix;
    };

    # sigint -- radio intelligence
    nixosConfigurations.sigint = nixosSystem {
      host = "sigint";
      system = "x86_64-linux";
      hardware = ./nixos/targets/sigint.nix;
    };

    # mess-around lab virtualisation machine, 16 core xeon, 192GB ram
    nixosConfigurations.kronos = nixosSystem {
      host = "kronos";
      system = "x86_64-linux";
      hardware = ./nixos/targets/efi-boot.nix;
    };

    /*
      VMs
    */

    # shell host vm configuration
    nixosConfigurations.shell = nixosSystem {
      host = "shell";
      system = "x86_64-linux";
      hardware = ./nixos/targets/qemu-guest.nix;
    };

    nixosConfigurations.torrent = nixosSystem {
      host = "torrent";
      system = "x86_64-linux";
      hardware = ./nixos/targets/qemu-guest.nix;
      modules = [
        ./nixos/modules/server.nix
        ./nixos/modules/user-josh.nix
      ];
    };

    nixosConfigurations.ops = nixosSystem {
      host = "ops";
      system = "x86_64-linux";
      hardware = ./nixos/targets/qemu-guest.nix;
      modules = [
        ./nixos/modules/server.nix
        ./nixos/modules/user-josh.nix
      ];
    };

    # home k8s vm instance using k3s
    nixosConfigurations.k8s = nixosSystem {
      host = "k8s";
      system = "x86_64-linux";
      hardware = ./nixos/targets/qemu-guest.nix;
    };

    # testing/playground vm
    nixosConfigurations.artemis = nixosSystem {
      host = "artemis";
      system = "x86_64-linux";
      hardware = ./nixos/targets/qemu-guest.nix;
      modules = [
        ./modules/server.nix
        ./modules/user-josh.nix
      ];
    };

    /*
      Surprise! Turns out home-manager has flake support!

      This is useful for providing my home configurations in non-NixOS contexts, like
      my work laptop, WSL2, etc where previously I was setting up a separate ~/.config/nixpkgs/home.nix
      file.
    */
    homeConfigurations.macbook = homeConfig {
      system = "aarch64-darwin";
      modules = [
        {
          home.homeDirectory = nixpkgs.lib.mkOverride 10 "/Users/josh";
          home.sessionPath = [
            "$HOME/.rd/bin"
          ];
        }
        hm/work.nix
        hm/darwin.nix
        hm/dev-tools.nix
      ];
    };

    homeConfigurations.wsl = homeConfig {
      system = "x86_64-linux";
      modules = [
        hm/dev-tools.nix
      ];
    };

    /*
     * EXPERIMENTAL STUFF
     */
    build-vm = vmImage {
      nixosConfiguration = self.nixosConfigurations.ops;
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

