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

commit_unreviewed_changes:
    -msg=${msg:-"CAUTION unreviewed changes. Broken Configuration!"}; git commit -m "$msg"
    

debug $RUST_BACKTRACE="1":
    just build

build:
    -nix flake update mysecrets
    -git add -A :/
    just commit_unreviewed_changes
    colmena build -p 3 
    echo -n "Enter commit message: "; read msg; msg=${msg:-"Same as last commit message (successful build, deployment not ready)."}; git commit --amend -m "$msg"

commit:
    -git add -A :/
    echo -n "Enter commit message: "; read msg; msg=${msg:-"CAUTION unreviewed changes. Broken Configuration!"}; git commit -m "$msg"

deploy target="all":
    -nix flake update mysecrets
    -git add -A :/
    just commit_unreviewed_changes
    just colmena {{target}}

colmena target:
    #!/usr/bin/env bash
    if ! colmena apply -p 3 --on @{{target}}; then
        @echo 'Recipe command failed!'
        git reset --soft HEAD~1
    else
        @echo 'Recipe command succeeded!'
        @echo -n 'Enter commit message: '; read msg; msg=${msg:-"Successful apply/deploy on @{{target}}! No commit message given."}; git commit --amend -m "$msg"
    fi

rebuild:
    nix --experimental-features 'nix-command flakes' flake update
    git add -A :/
    nohup sh -c 'colmena apply -p 3 && git commit -m "build and deployment succesfull" && git push' > nohup.out 2>&1 &

#deploy laptop:
# nix run github:nix-community/nixos-anywhere -- --extra-files ~/.config/sops/age --generate-hardware-config nixos-generate-config ./hosts/laptop/hardware-configuration.nix root@192.168.12.122 --flake .#laptop



# echo {{ if target == "" { "all" } else { target } }}
# -just update
