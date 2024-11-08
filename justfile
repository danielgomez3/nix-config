default:
    @just --list

update:
    nix --experimental-features 'nix-command flakes' flake update
    git add -A :/
    echo -n "Enter commit message: "; read msg; git commit -m "$msg"
    git push

# TODO: Can't just do it for server, moron
# rebuild:
#     sudo -E nix flake lock --update-input mysecrets
#     sudo nixos-rebuild switch --flake .#server

# edit:
#     $EDITOR . 
#     just update
#     just rebuild

# TODO: deploy to all systems
# deploy target user ip:
#     @echo 'Building {{target}}…'
#     nix run github:nix-community/nixos-anywhere -- --extra-files ~/.config/sops/age --generate-hardware-config nixos-generate-config ./hosts/{{target}}/hardware-configuration.nix {{user}}@{{ip}} --flake .#{{target}}

netboot:
    # nix build -f ./extra/nix-expressions/netboot/system.nix -o /tmp/run-pixiecore
    sudo iptables -w -I nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    sudo iptables -w -I nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT

    # Now run this command in your terminal to start pixiecore:
    sudo $(realpath /tmp/run-pixiecore)
    # Close ports
    # sudo iptables -w -D nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    # sudo iptables -w -D nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT

rebuild:
    # NOTE: rebuilds and applies to whoever is online and reachable.
    colmena build -p 3 && colmena apply -p 3

#deploy laptop:
# nix run github:nix-community/nixos-anywhere -- --extra-files ~/.config/sops/age --generate-hardware-config nixos-generate-config ./hosts/laptop/hardware-configuration.nix root@192.168.12.122 --flake .#laptop
