
# Deployment

The following are steps to accomplish deploying a NixOS machine.
An alternate or lesser set of steps derived from <https://nix-community.github.io/nixos-anywhere/quickstart.html>.

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
1. Disable secure boot in the bios on target machine (for Windows machines).
<!-- TODO: For what purpose?: -->
1. Do an initial connect to the netbooted system's root user, not the normal user via SSH (the IP address will be shown on the netboot screen): `ssh root@<ip_address>`
