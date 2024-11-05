default:
    @just --list

update:
    nix --experimental-features 'nix-command flakes' flake update
    git add -A :/
    echo -n "Enter commit message: "; read msg; git commit -m "$msg"

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
