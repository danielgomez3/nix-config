default:
    @just --list

netboot:
    # nix build -f ./extra/nix-expressions/netboot/system.nix -o /tmp/run-pixiecore
    sudo iptables -w -I nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    sudo iptables -w -I nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT
    sudo $(realpath /tmp/run-pixiecore)
    # Close ports
    # sudo iptables -w -D nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    # sudo iptables -w -D nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT

# update:
#   nix flake update
#   nix flake lock



apply target="all":
    -nix flake lock --update-input mysecrets
    -git add -A :/; msg=${msg:-"CAUTION untested changes, possibly broken"}; git commit -m "$msg"; 
    colmena apply -p 3 --on @{{target}} && git push

rebuild:
    nix --experimental-features 'nix-command flakes' flake update
    git add -A :/
    nohup sh -c 'colmena apply -p 3 && git commit -m "deployed succesfully" && git push' > nohup.out 2>&1 &

#deploy laptop:
# nix run github:nix-community/nixos-anywhere -- --extra-files ~/.config/sops/age --generate-hardware-config nixos-generate-config ./hosts/laptop/hardware-configuration.nix root@192.168.12.122 --flake .#laptop



# echo {{ if target == "" { "all" } else { target } }}
# -just update
