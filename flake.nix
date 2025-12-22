{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

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

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nixos-hardware,
      nixos-wsl,
      nix-darwin,
      home-manager,
      agenix,
    }:
    let

      configVersion = self.rev or "dirty";
      nixosSystem = import lib/nixosSystem.nix { inherit nixpkgs home-manager configVersion; };

    in
    {

      # Lenovo Thinkpad X1 (7th Gen)
      nixosConfigurations.aether = nixosSystem {
        host = "aether";
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
          nixos/targets/thinkpad_x1.nix
        ];
      };

      # Desktop, WSL
      nixosConfigurations.erebus = nixosSystem {
        host = "erebus";
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          {
            wsl = {
              enable = true;
              defaultUser = "josh";
            };
          }
        ];
      };

      nixosConfigurations.straylight = nixosSystem {
        host = "straylight";
        system = "x86_64-linux";
        modules = [
          nixos/targets/straylight.nix
        ];
      };

      nixosConfigurations.x220 = nixosSystem {
        host = "x220";
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-x220
          nixos/targets/thinkpad_x220.nix
        ];
      };

      # new linux workstation for futzing with ml
      nixosConfigurations.arcimedes = nixosSystem {
        host = "arcimedes";
        system = "x86_64-linux";
        modules = [
          nixos/targets/efi-boot.nix
        ];
      };

      # oracle cloud a1 vm
      nixosConfigurations.armitage = nixosSystem {
        host = "armitage";
        system = "aarch64-linux";
        modules = [
          nixos/targets/oci.nix
        ];
      };

      # Cobbled together i7-3770 workstation in the garage
      nixosConfigurations.garage = nixosSystem {
        host = "garage";
        system = "x86_64-linux";
        modules = [
          nixos/targets/ugh.nix
        ];
      };

      # sigint -- radio intelligence
      nixosConfigurations.sigint = nixosSystem {
        host = "sigint";
        system = "x86_64-linux";
        modules = [
          nixos/targets/sigint.nix
        ];
      };

      # mess-around lab virtualisation machine, 16 core xeon, 192GB ram
      nixosConfigurations.kronos = nixosSystem {
        host = "kronos";
        system = "x86_64-linux";
        modules = [
          nixos/targets/efi-boot.nix
        ];
      };

      # VMs

      # shell host vm configuration
      nixosConfigurations.shell = nixosSystem {
        host = "shell";
        system = "x86_64-linux";
        modules = [
          nixos/targets/qemu-guest.nix
        ];
      };

      nixosConfigurations.torrent = nixosSystem {
        host = "torrent";
        system = "x86_64-linux";
        modules = [
          nixos/targets/qemu-guest.nix
        ];
      };

      nixosConfigurations.ops = nixosSystem {
        host = "ops";
        system = "x86_64-linux";
        modules = [
          nixos/targets/qemu-guest.nix
        ];
      };

      # home k8s vm instance using k3s
      nixosConfigurations.k8s = nixosSystem {
        host = "k8s";
        system = "x86_64-linux";
        hardware = ./nixos/targets/qemu-guest.nix;
        modules = [
          nixos/targets/qemu-guest.nix
        ];
      };

      # testing/playground vm
      nixosConfigurations.artemis = nixosSystem {
        host = "artemis";
        system = "x86_64-linux";
        modules = [
          #nixos/targets/qemu-guest.nix
          #./nixos/modules/incus-image.nix
          #"${nixpkgs}/nixos/modules/virtualisation/lxc-container.nix"
        ];
      };

      nixosConfigurations.lxc-guest = nixosSystem {
        host = "lxc-guest";
        system = "x86_64-linux";
      };

      # Giving nix-darwin a shot
      darwinConfigurations."joshs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.josh = {
              home.sessionPath = [
                "$HOME/.rd/bin"
              ];
              programs.ssh.matchBlocks."*".identityFile = [
                "~/.ssh/josh@fulcradynamics.com.key"
              ];
              home.stateVersion = "25.11";
              imports = [
                home-manager/josh/config.nix
                home-manager/josh/work.nix
                hm/darwin.nix
                home-manager/development.nix
                home-manager/josh/workstation.nix
              ];
            };
          }

          {
            nixpkgs.hostPlatform = "aarch64-darwin";
            nixpkgs.overlays = import ./lib/overlays.nix;
            system.stateVersion = 6;
            system.configurationRevision = self.rev or self.dirtyRev or null;
            nix.settings.experimental-features = "nix-command flakes";
            ids.gids.nixbld = 30000;
            environment.systemPackages = with nixpkgs.legacyPackages.aarch64-darwin; [
              vim
            ];
            users.users.josh.home = "/Users/josh";
          }

        ];

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
