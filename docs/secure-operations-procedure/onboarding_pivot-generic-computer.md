---
author: Daniel Gomez
date: 2025-04-09
title: SOP NixOS pivot computer onboarding
---

# Introduction
In order for *any* NixOS machine to be created or deployed, a first pivot machine with a capable compute (a build host) must be created by which all other machines can be created and managed. We will call this machine the **server**.

# Steps

## Basic configuration
1. Install NixOS on the server with a USB installer or otherwise.
1. Initialize a git repo, or download an existing github repo with the nix flake code. We assume it called **nix-config**.

## Nix Secrets management
1. Initialize a git repo, or download an existing github repo with the nix flake secrets. We assume it called **nix-secrets**.



## Register Tailscale with email, or login if already created
