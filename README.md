# 🤗 A Simply educational Nix Flake ❄️ 🎓

> A learning framework for those new to Nix Flakes and Linux deployment.

## TODO
Completely refactor flake.nix

## Problem
  - I manage two systems, a laptop and a desktop. I want some similarity in their configuration, and some differences.
  - I want infrastructure as code --> 🤓 (you).
  - I don't want to overcomplicate with *another* build tool 🙄.

## Solution
  - A declarative Operating System (or file) with reproduceability baked-in :)


#### Opinions
  - Docker is not as reproducible as you think. It comes with some big drawbacks, and It doesn't ever fix the underlying issue of non-determinism when using non-declaritive Operating Systems.

#### Learn
  - Follow the breadcrumbs in the `flake.nix` file.
  - After cloning this repository and moving files into `etc/nixos`, Here's how you can view the current existing configurations:
  ```nix
  ❯ sudo nix flake show                      
    git+file:///etc/nixos?ref=refs/heads/main&rev=dc80b702a572984635f4ac0cebf6b457c204ce4f
    └───nixosConfigurations
        ├───desktop: NixOS configuration
        └───laptop: NixOS configuration
  ```

#### Background
  - After careful consideration, There are only 3 necessary files!
    + `flake.nix` The entry point for our program/configuration.
    + At least one unique configuration, such as a `desktop.nix`, or a `server.nix`, that contains system-level, hardware-level, and home-manager options for the unique system (When you have more servers or systems, you can create more `_.nix` files with similar structure).
    + A `configuration.nix` that contains universal options for all your systems.
  - `hardware-configuration.nix` is to be merged with your unique flake config for simplicity!
  - This could also fit inside one singular `flake.nix` file, but you'll find that that breaks modularity!
g
