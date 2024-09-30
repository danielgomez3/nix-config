default:
    @just --list

update:
    git add -A :/
    sudo nix flake update

rebuild:
    just update
    sudo nix flake lock --update-input mysecrets
    sudo nixos-rebuild switch --flake .#server

edit:
    $EDITOR . 
    just rebuild

deploy:
    update
    # TODO: deploy to all systems

