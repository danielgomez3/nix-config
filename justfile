default:
    @just --list

update:
    nix flake update

rebuild:
    nix flake lock --update-input mysecrets
    nixos-rebuild switch --flake .#server

deploy:
