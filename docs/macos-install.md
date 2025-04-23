# Introduction
Based off of <https://nixcademy.com/posts/nix-on-macos/>.
Assuming there are no provisions for a macOS NixOS machine, meaning no nix code, and only a fresh installation of macOS:

# Preparing the macOS device

1. Use the determinate Nix installer `https://github.com/DeterminateSystems/nix-installer`.

Don't install determinate-nix, install the nixos.org one via the determinate system nix-installer.
The Nix package manager is installed, the nix store is encrypted in an encrypted APFS volume added to fstab mounting on `/nix`.

1. Test binary:
```bash
exec $SHELL
nix run nixpkgs#hello
# Should return Hello, World!
```

1. Allow an SSH connectivity imperatively by downloading Tailscale.

1. Connect via SSH.

This is a pain in the butt. Just give the mac device your ssh key.



# Deploying Flake


