default:
    @just --list

update:
    git add -A :/
    sudo nix flake update

rebuild:
    sudo nix flake lock --update-input mysecrets
    sudo nixos-rebuild switch --flake .#server

edit:
    $EDITOR . 
    just update
    just rebuild

deploy:
    update
    # TODO: deploy to all systems

