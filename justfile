# FIXME: it might not be necessary to surround {{}} with quotes

default:
    @just --list


# NOTE: Do not use lightly
# update:
#   nix flake update
#   nix flake lock







# #
# Internal use, helpers
# #

host := "`hostname`"
msg_build_success := "Successful build! No commit message given."
msg_apply_success := "Successful colmena apply on target(s)! No commit message given"

# NOTE: Targets would have to use the mako module in this flake repo for this to work
_notify_targets target:
    @echo "{{target}}"
    @for target in $(echo {{target}} | tr ',' ' '); do \
        echo $target; ssh "$target" "notify-send 'Task Complete' 'Server command has finished running.'"; \
    done

_commit_unreviewed_changes:
    @-git add -A :/
    @-msg=${msg:-"CAUTION unreviewed changes. Broken Configuration!"}; git commit -m "$msg"
    
_commit_successful_changes default_message:
    @echo -n "(optional) Enter commit message (20s timeout): "; \
    read -t 20 msg || msg=""; \
    msg=${msg:-"{{default_message}}"}; \
    git commit --amend -m "$msg"

_colmena_apply target:
    #!/usr/bin/env bash
    if ! colmena apply -p 3 --on @{{target}}; then  # If apply fails, erase default commit mesage
        git reset --soft HEAD~1
    else
        -just _notify_targets {{target}}
        just _commit_successful_changes "{{msg_apply_success}}"
    fi







    
# #
# Building, applying, tasks
# #

update_secrets:
    @-nix flake update mysecrets

build notification_target:
    just update_secrets
    just _commit_unreviewed_changes
    colmena build -p 3 
    just _notify_targets {{notification_target}}
    just _commit_successful_changes "{{msg_build_success}}"

apply target=(host):
    just update_secrets
    just _commit_unreviewed_changes
    just _colmena_apply {{target}}

garbage:
    nix-collect-garbage -d --delete-older-than 5d
    
save:
    @echo "{{ style("error") }}WARNING! This isn't a good idea.. very undynamic of you to do.{{ NORMAL }}"
    -git add -A :/
    just _commit_successful_changes "{{msg_build_success}}"











## 
# Using REPL, debugging
## 

debug $RUST_BACKTRACE="1":
    just build

debug-with-repl:
    export NIX_PATH=nixpkgs=flake:nixpkgs && colmena repl

repl:
    # nix repl --file ./lib/nix-expressions/learning-testing-examples/helpers.nix
    cd {{invocation_directory()}}; nix repl --extra-experimental-features 'flakes' --file {{justfile_directory()}}/testing/learning-testing-examples/helpers.nix

repl-flake:
    cd {{invocation_directory()}}; nix repl --extra-experimental-features 'flakes' --expr "import \"{{justfile_directory()}}/testing/learning-testing-examples/withSelf.nix\""
    






# #
# Deployment, provisioning
# #


[confirm("Are you sure you want to potentially erase this machine's disk and deploy?")]
deploy host ip_address:
    nix run github:nix-community/nixos-anywhere -- --extra-files ~/.config/sops/age --generate-hardware-config nixos-generate-config ./hosts/{{host}}/hardware-configuration.nix root@{{ip_address}} --flake .#{{host}}

generate-age-keys:
    mkdir --parents ~/.config/sops/age
    nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt
    # nix run nixpkgs#ssh-to-age -- private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt

init-machine username host:
    @cp -r {{justfile_directory()}}/lib/templateHost {{justfile_directory()}}/hosts/{{host}}
    @sed -i.bak -e "s/USERNAME/{{username}}/" -e "s/HOSTNAME/{{host}}/" {{justfile_directory()}}/hosts/{{host}}/default.nix
    echo "Replacement completed. Backup saved as 'default.nix.bak'."
   
netboot:
    nix build -f ./lib/nix-expressions/netboot/system.nix -o /tmp/run-pixiecore
    -sudo iptables -w -I nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    -sudo iptables -w -I nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT
    sudo $(realpath /tmp/run-pixiecore)
    # Close ports
    # sudo iptables -w -D nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    # sudo iptables -w -D nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT
