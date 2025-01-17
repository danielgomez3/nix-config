default:
    @just --list


# update:
#   nix flake update
#   nix flake lock

msg_build_success := "Successful build! No commit message given."
msg_deploy_success := "Successful apply/deploy on @{{target}}! No commit message given"

update_secrets:
    @-nix flake update mysecrets
    

commit_unreviewed_changes:
    @-git add -A :/
    @msg=${msg:-"CAUTION unreviewed changes. Broken Configuration!"}; git commit -m "$msg"
    
commit_successful_changes default_message="No commit message given.":
    @echo -n "(optional) Enter commit message: "; read msg; msg=${msg:-"{{default_message}}"}; git commit --amend -m "$msg"

debug $RUST_BACKTRACE="1":
    just build

build:
    just update_secrets
    just commit_unreviewed_changes
    colmena build -p 3 
    just commit_successful_changes "{{msg_build_success}}"

# NOTE: Don't use, because it's not very dynamic of you.
# commit:
#     -git add -A :/
#     echo -n "Enter commit message: "; read msg; msg=${msg:-"CAUTION unreviewed changes. Broken Configuration!"}; git commit -m "$msg"

deploy target="all":
    just update_secrets
    just commit_unreviewed_changes
    just colmena {{target}}

colmena target:
    #!/usr/bin/env bash
    if ! colmena apply -p 3 --on @{{target}}; then
        git reset --soft HEAD~1
    else
        just commit_successful_changes "{{msg_deploy_success}}"
    fi














#deploy laptop:
# nix run github:nix-community/nixos-anywhere -- --extra-files ~/.config/sops/age --generate-hardware-config nixos-generate-config ./hosts/laptop/hardware-configuration.nix root@192.168.12.122 --flake .#laptop



netboot:
    # nix build -f ./extra/nix-expressions/netboot/system.nix -o /tmp/run-pixiecore
    sudo iptables -w -I nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    sudo iptables -w -I nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT
    sudo $(realpath /tmp/run-pixiecore)
    # Close ports
    # sudo iptables -w -D nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    # sudo iptables -w -D nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT
