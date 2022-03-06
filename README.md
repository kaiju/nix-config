# nix-config

> "This place is not a place of honor... no highly esteemeed deed is commemorated here... nothing valued is here."

This repository contains my personal NixOS & Home Manager configurations across multiple machines.

## NixOS Configuration

All hosts are defined as `nixosConfigurations` outputs in `flake.nix`.

A host's configuration can be updated by running `nixos-rebuild switch --flake '.'`.
