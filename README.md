# nix-config

This repository contains my personal NixOS & Home Manager configurations across multiple machines.

## NixOS Configuration

`/etc/nixos/configuration.nix` serves as a simple bootstrap for loading in the `hardware-configuration.nix` module typically generated during install and the appropriate host module from `hosts/`:

```
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /home/josh/nix-config/hosts/garage.nix
    ];

  system.stateVersion = "20.09"; # Did you read the comment?

}
```

## Common Configuration

Common NixOS configurations are shared as modules in `roles/` that can be imported into host modules.

## Home Manager

On NixOS systems Home Manager configurations are applied via the `home-manager` module as defined in `roles/user-josh.nix`. Individual NixOS hosts then define modules from `home-manager/` to import from their `hosts/` module.
