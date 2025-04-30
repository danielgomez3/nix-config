# https://nixos.wiki/wiki/Flakes
# This will launch a 'nix repl' with access to nixpkgs, lib, and the flake options in a split of a second, instead of manually loading it in or doing some acrobatics in the justfile or with args.
let
  flake = builtins.getFlake (toString ./.);
  nixpkgs = import <nixpkgs> { };
in
{ inherit flake; }
// flake
// builtins
// nixpkgs
// nixpkgs.lib
// flake.nixosConfigurations
