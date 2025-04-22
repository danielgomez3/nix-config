---
author: Daniel Gomez
date: 2025-04-09
title: SOP NixOS android onboarding
---

# Prerequisites
- Pivot device must be created.
- Pivot device may have an HTTP server

# Instructions

# Install nix-on-droid to android device from a pivot device
This allows for your desired packages like `openssh` and `rsync` to be pre-installed that wouldn't otherwise through manually installing the nix-on-droid app.

On the target android device:
1. Imperatively install and configure Tailscale to allow routing between devices. This is necessary to do because:
  - a.) NixOS modules don't exist yet for nix-on-droid, where Tailscale would normally be enabled.
  - b.) We need to execute the github repo nix flake code, build the system closure on a server as a build host, and deploy it to the android device. Finally deploying the system build closure is only possible via a remote connection to the HTTP server where the build is hosted.


On the NixOS pivot device, we'll call it **server**:
1. Clone the nix-on-droid repository.
1. Run the following command in the following command: `nix run ".#deploy"`

<!-- # OPTION 2: Install nix-on-droid to android device -->
<!-- On the android device: -->
<!-- 1. Download F-Droid. -->
<!-- 1. On F-Droid, download Nix-on-Droid -->
<!-- 1. Accept Flakes as option. This can take up to an hour because of android power management. Faster if you accept the wakelock. Be patient. -->
<!-- NOTE: Actually, this might not be the case? -->
<!-- 1. Imperatively install and configure Tailscale to allow this kind of ssh access: server-to-android. Not the other way around, this could be an unnecessary vulnerability. This is necessary to do because -->
<!-- a.) NixOS modules don't exist yet for nix-on-droid, where Tailscale would normally be enabled. -->
<!-- b.) We need to execute the github repo nix flake code, build the system closure on the server as a build host, and deploy it to the android device. Finally deploying the system build closure is only possible via an ssh connection. -->


## Establish server → android ssh connection  

<!-- ## OPTION 2: Establish server → android ssh connection (Locally via the nix-on-droid app) -->
<!-- Ideally, this would be done declaratively with a deployment tool like nixos-anywhere or terraform-nixos. But this must be done imperatively for now, as this is not a normal NixOS compatible device. -->

Option 1: Imperatively, generic NixOS devices.
1. Enable ssh access on android device <https://github.com/nix-community/nix-on-droid/issues/32>.
1. Establish ssh connection imperatively by adding android devices keys to server's *.nix code.
1. Enable remote building on server device with code: <https://github.com/nix-community/nix-on-droid/wiki/Simple-remote-building>.

Option 2: Imperative w/nixos-option, slightly more declarative.
1. WIP: <https://github.com/nix-community/nix-on-droid/pull/203>




## Build and deploy config from server
- `--impure` flag needs to be used, because as of now the nix store paths are hardcoded on nix-on-droid (?).

# Optional: Syncthing
1. Imperatively install syncthing. Add keys imperatively to flake repo code.
