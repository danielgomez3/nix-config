default:
    @just --list

update:
    git add -A :/; git commit -m "just update";
    # nix flake update
    sudo nix --extra-experimental-features "nix-command flakes" flake update
    # nix flake lock
    # sudo nix flake lock
    # nix flake lock --update-input mysecrets

# TODO: Can't just do it for server, moron
# rebuild:
#     sudo -E nix flake lock --update-input mysecrets
#     sudo nixos-rebuild switch --flake .#server

edit:
    $EDITOR . 
    just update
    just rebuild

# TODO: deploy to all systems
deploy:
    update

netboot:
    nix build -f extra/nix-expressions/netboot/system.nix -o /tmp/run-pixiecore
    sudo $(realpath /tmp/run-pixiecore)
