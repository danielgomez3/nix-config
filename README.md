# Synopsis

What this repository is:
- A Linux System and IaC using `Nix`, a functional programming language and package manager. This includes users, permissions, apps, directories, and services that would exist on each different machine, and all of your choosing.

# Use

Via this repository, one may to accomplish the following:
- A fully automated, declarative, and remote install of a Linux machine.
- Pulling from a separate and private git repository of encrypted secrets (e.g <https://github.com/ficticioususer/my-nix-secrets>) (using `age` for encryption, and edited on host environment with `sops`). This private repository would store the user passwords, hostnames, even online credentials that would be ready on a new undeployed Linux system.
- Deployment on computer hardware via a network connection. Instant SSH access to each deployed machine using any of the following tools:
  - Deploying via PXE boot using `netboot.xyz`.
  - Deploying instantly on a cloud platform resource (like GCP, Azure, etc.) using `terrraform`.
- Doing so in parallel using a deployment module called `colmena`.
- Optional passwordless login via Yuibikey.


# Structure

The `flake.nix` file declaratively describes the Linux machines that may exist and be deployed. The `/hosts/` directory guides the flow of what characteristics those machines would contain. The `/modules/` directory contains those said modules, programs, etc to be inherited by the hosts. 
