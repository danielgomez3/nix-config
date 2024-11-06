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

netboot:
    nix build -f ./extra/nix-expressions/netboot/system.nix -o /tmp/run-pixiecore
    sudo iptables -w -I nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    sudo iptables -w -I nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT

    # Now run this command in your terminal to start pixiecore:
    #sudo $(realpath /tmp/run-pixiecore)

#deploy laptop:
# nixos-anywhere --extra-files ~/.config/sops/age --generate-hardware-config nixos-generate-config ./hosts/laptop/hardware-configuration.nix --flake '.#laptop' root@192.168.12.118
