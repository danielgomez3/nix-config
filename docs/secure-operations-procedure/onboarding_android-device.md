---
author: Daniel Gomez
date: 2025-04-09
title: SOP NixOS android onboarding
---

# Prerequisites
Pivot computer must be created.

On the android device:
1. Download F-Droid.
1. On F-Droid, download Nix-on-Droid
1. Accept Flakes as option. This can take up to an hour because of android power management. Faster if you accept the wakelock. Be patient.
<!-- NOTE: Actually, this might not be the case? -->
1. Imperatively install and configure Tailscale to allow this kind of ssh access: server-to-android. Not the other way around, this could be an unnecessary vulnerability. This is necessary to do because
a.) NixOS modules don't exist yet for nix-on-droid, where Tailscale would normally be enabled.
b.) We need to execute the github repo nix flake code, build the system closure on the server as a build host, and deploy it to the android device. Finally deploying the system build closure is only possible via an ssh connection.

# Instructions

## Establish server → android ssh connection 


# Optional: Syncthing
1. Imperatively install syncthing. Add keys imperatively to flake repo code.
