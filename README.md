# nix-config

> "This place is not a place of honor... no highly esteemed deed is commemorated here... nothing valued is here."

 This repository contains my personal NixOS & Home Manager configurations for multiple machines. This configuration
is an eternal work-in-progress as I stumble my way through the ins and outs of Nix. I've done my best to document
some of the speedbumps I've hit along with what I've learned via comments.

## Project Layout

- `flake.nix`: All system configurations are managed as Nix Flake outputs
- `lib/`: Additional functions, evaluations, and imports
- `mastpkgs/`: My own personal Nix packages used in my configurations
- `nixos/targets`: NixOS hardware/platform target configs
- `nixos/hosts`: Host-specific NixOS configuration
- `nixos/modules`: Common NixOS configuration modules
- `hm/`: Home Manager modules

## Building NixOS Systems

NixOS System configuration can be built from flakes by passing the `nixpkgs.lib.nixosSystem {}` function to a `nixosConfigurations.<name>` output:

```
{
  outputs = { self, nixpkgs }:
  {
    nixosConfigurations.example = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        configuration.nix
      ];
    }
  }
}
```

As my configuration grew and I added more systems, I got tired of the amount of attrset boilerplate I repeated for each system. I decided to abstract it in my own `nixosSystem` ([lib/nixosSystem.nix](lib/nixosSystem.nix)) function that applies a common configuration pattern across all systems. 

The `nixosSystem` function wraps `nixpkgs.lib.nixosSystem` and passes in NixOS modules common to all systems such as [Home Manager](https://github.com/nix-community/home-manager), the base configuration module, and nixpkgs overlays as well as appropriate modules from the `nixos/targets/` and `nixos/hosts/` directories.

I typically build system configurations on a single machine and deploy them to other hosts:

`# nixos-rebuild switch --flake '.#<host>' --target-host <hostname> --use-remote-sudo`

## Building Home Configuration

[Home Manager](https://github.com/nix-community/home-manager) has support for building home configurations from `homeConfigurations` flake outputs. This is handy for deploying my home configuration on non-NixOS hosts like WSL & OSX.

`# home-manager switch --flake '.#<profile>'`
