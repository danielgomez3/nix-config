# Introduction
Assuming there are no provisions for a macOS NixOS machine, meaning no nix code, and only a fresh installation of macOS:

# Preparing the macOS device

1. Use the determinate Nix installer, not the official nixos.org one `https://github.com/DeterminateSystems/nix-installer`.

The Nix package manager is installed, the nix store is encrypted in an encrypted APFS volume added to fstab mounting on `/nix`.

1. Test binary:
```bash
exec $SHELL
nix run nixpkgs#hello
# Should return Hello, World!
```

# Preparing flake
