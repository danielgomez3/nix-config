default:
    @just --list

update:
    git add -A :/
    nix flake update
    nix flake lock --update-input mysecrets

# TODO: Can't just do it for server, moron
# rebuild:
#     sudo -E nix flake lock --update-input mysecrets
#     sudo nixos-rebuild switch --flake .#server

edit:
    $EDITOR . 
    just update
    just rebuild

deploy:
    update
    # TODO: deploy to all systems

