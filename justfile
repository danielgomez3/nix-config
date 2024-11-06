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
    # Build pixiecore runner
    nix build -f ./extra/nix-expressions/netboot/system.nix -o /tmp/run-pixiecore

    # Open required firewall ports
    sudo iptables -w -I nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    sudo iptables -w -I nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT

    # Run pixiecore
    sudo $(realpath /tmp/run-pixiecore)

    # Close ports
    sudo iptables -w -D nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    sudo iptables -w -D nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT

