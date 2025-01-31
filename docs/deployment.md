
# Deployment

The following are steps to accomplish deploying a NixOS machine.

## Prerequisites

- A machine (acting as server, referred to as 'server') that can run the 'Nix' package manager.
- A target machine (hardware or cloud resource).

### Windows

As per <https://nixos.org/download/#nix-install-windows>:
`$ sh <(curl -L https://nixos.org/nix/install) --no-daemon`.

### MacOS

As per <https://nixos.org/download/#nix-install-macos>:
`sh <(curl -L https://nixos.org/nix/install)`.


## TODO

## Connect to target
Connect to the net-booted system's root user, not normal user.
