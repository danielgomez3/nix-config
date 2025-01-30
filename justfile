default:
    @just --list


# update:
#   nix flake update
#   nix flake lock

host := "`hostname`"
msg_build_success := "Successful build! No commit message given."
msg_apply_success := "Successful apply/apply on @{{target}}! No commit message given"

update_secrets:
    @-nix flake update mysecrets
    

_commit_unreviewed_changes:
    @-git add -A :/
    @-msg=${msg:-"CAUTION unreviewed changes. Broken Configuration!"}; git commit -m "$msg"
    
_commit_successful_changes default_message:
    @echo -n "(optional) Enter commit message: "; read msg; msg=${msg:-"{{default_message}}"}; git commit --amend -m "$msg"

_colmena_apply target:
    #!/usr/bin/env bash
    if ! colmena apply -p 3 --on @{{target}}; then  # If apply fails, erase default commit mesage
        git reset --soft HEAD~1
    else
        just _commit_successful_changes "{{msg_apply_success}}"
    fi

debug $RUST_BACKTRACE="1":
    just build

build:
    just update_secrets
    just _commit_unreviewed_changes
    colmena build -p 3 
    just _commit_successful_changes "{{msg_build_success}}"

apply target=(host):
    just update_secrets
    just _commit_unreviewed_changes
    just _colmena_apply {{target}}

garbage:
    nix-collect-garbage -d --delete-older-than 10d
    
save:
    @echo "{{ style("error") }}WARNING! This isn't a good idea.. very undynamic of you to do.{{ NORMAL }}"
    -git add -A :/
    echo -n "Enter commit message: "; read msg; msg=${msg:-"CAUTION unreviewed changes. Broken Configuration!"}; git commit -m "$msg"




## 
# Using REPL
## 

debug-with-repl:
    export NIX_PATH=nixpkgs=flake:nixpkgs && colmena repl

repl:
    # nix repl --file ./lib/nix-expressions/learning-testing-examples/helpers.nix
    cd {{invocation_directory()}}; nix repl --extra-experimental-features 'flakes' --file {{justfile_directory()}}/testing/learning-testing-examples/helpers.nix

repl-flake:
    cd {{invocation_directory()}}; nix repl --extra-experimental-features 'flakes' --expr "import \"{{justfile_directory()}}/testing/learning-testing-examples/withSelf.nix\""
    










#deploy laptop:
# nix run github:nix-community/nixos-anywhere -- --extra-files ~/.config/sops/age --generate-hardware-config nixos-generate-config ./hosts/laptop/hardware-configuration.nix root@192.168.12.122 --flake .#laptop

# deploy machine:
#     nix run github:nix-community/nixos-anywhere -- --extra-files ~/.config/sops/age --generate-hardware-config nixos-generate-config ./hosts/{{machine}}/hardware-configuration.nix root@192.168.12.122 --flake .#{{machine}}

generate-keys:
    mkdir --parents ~/.config/sops/age
    ssh-to-age -- private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
    

netboot:
    nix build -f ./lib/nix-expressions/netboot/system.nix -o /tmp/run-pixiecore
    -sudo iptables -w -I nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    -sudo iptables -w -I nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT
    sudo $(realpath /tmp/run-pixiecore)
    # Close ports
    # sudo iptables -w -D nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    # sudo iptables -w -D nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT
