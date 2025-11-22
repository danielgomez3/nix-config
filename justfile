# #
# NOTE:
# Lines with @ supress justfile printing executed line to standard output, not supress standard output altogether.
# Lines with @- do that and run regardless of command success
# #

host := "`hostname`"
msg_default := "System build failed, commit broken!"
msg_build := "No commit message given, building system, commit possibly broken!"
msg_success := "Successful system build and/or apply to targets:" 
# devices := "server test-machine nas-server llm-machine living-room hetzner-vps desktop laptop
# iso := `ls result/iso/*.iso`

[confirm("This will possibly break configuration, do not use lightly.. (y/n)")]
update:
  nix flake update
  nix flake lock

_update_secrets:
    @nix flake update mysecrets

   
push:
    git add -A :/
    git commit
    git push
    
# target examples (default: your hostname):
# just apply laptop,server,desktop
# apply-remote:
#     # One method
#     nohup bash -c 'for i in {server,test-machine,nas-server,llm-machine,living-room,hetzner-vps}; do just deploy-rs "$i"; done' > /var/log/just-apply-remote.log 2>&1 &

# Deploy them in parallel, non-deterministically
apply-all:
    #!/usr/bin/env bash
    # TODO: add usb device(s)
    # TODO: make into one-off systemd unit?
    : > /var/tmp/just-apply_all.log
    just _update_secrets
    git add --all
    for i in server test-machine nas-server llm-machine living-room hetzner-vps desktop laptop; do
        nohup nix run github:serokell/deploy-rs --show-trace -- --skip-checks ".#$i" \
        | tee -a /var/tmp/just-apply_all.log \
        | tee "/var/tmp/just-apply_$i.log" >/dev/null &
    done 
    

apply target=(host):
    #!/usr/bin/env bash
    just _update_secrets
    git add --all
    input="{{target}}"
    IFS=',' read -r -a devices <<< "$input"
    for i in "${devices[@]}"; do
      nix run github:serokell/deploy-rs --show-trace -- --skip-checks ".#$i"
    done


# TODO: simple refactor, WIP
deploy-rs target=(host):
      nix run github:serokell/deploy-rs --show-trace -- --skip-checks ".#{{target}}"


# Validates syntax and module structure, no build or result.
eval target=(host):
    git add -A :/
    nix eval ".#nixosConfigurations.{{target}}.config.system.build.toplevel.drvPath"
    # #!/usr/bin/env bash
    # input="{{target}}"
    # IFS=',' read -r -a devices <<< "$input"
    # for i in "${devices[@]}"; do
    #   nix eval '.#nixosConfigurations.".#$i".config.system.build.toplevel.drvPath'
    # done

# Same as eval, but for all configurations

# eval and build, result is stored in ./result symlink
build target=(host):
    nix build .#nixosConfigurations.{{target}}.config.system.build.toplevel # same as: nixos-rebuild build --flake ".#{{target}}" 

    

    




# #
# NOTE: Extra recipes
# #    

garbage:
    nix-collect-garbage -d --delete-older-than 5d   

# NOTE: You can run this in any directory with the desired .nix file(s) in the invocation dir.
repl:
    nix repl --file repl.nix
    # nix repl -f '<nixpkgs>'


debug $RUST_BACKTRACE="1":
    just build

debug-with-repl:
    export NIX_PATH=nixpkgs=flake:nixpkgs && colmena repl


# Used to play with nix expressions, and use against my flake.
repl-flake:
    git add -A :/
    cd {{invocation_directory()}}; nix repl --extra-experimental-features 'flakes' --expr "import \"{{justfile_directory()}}/lib/learning-nix/learning-nix.nix\""

[confirm("This might potentially erase a directory/host with the same name. Continue? NOTE: do not use single quotes for desc or names!")]
new host username block_device description:
    [ ! -d "./hosts/{{host}}" ] && scp -r ./lib/deployment/templateHost ./hosts/{{host}} || false
    sed -i -E 's/\bxxusernamexx\b/{{username}}/g' ./hosts/{{host}}/*.nix
    sed -i -E 's/\bxxhostnamexx\b/{{host}}/g' ./hosts/{{host}}/*.nix
    sed -i -E 's/\bxxdescriptionxx\b/{{description}}/g' ./hosts/{{host}}/*.nix
    sed -i -E 's|\bxxblock_devicexx\b|{{block_device}}|g' ./hosts/{{host}}/*.nix
    git add -A :/

# Works with closed laptop lids, etc.
[confirm("Are you sure you want to potentially erase target machine's disk and deploy?")]
deploy username host ip_address:
    # Create a custom kexec tarball for nixos-anywhere to use
    nix build .#custom-kexec
    # create buffer to migrate age keys
    root_dir=$(mktemp -d) && \
    trap 'rm -rf "$root_dir"' EXIT && \
    mkdir -p "${root_dir}/root/.config/sops/age" && \
    cp ~/.config/sops/age/keys.txt "${root_dir}/root/.config/sops/age/keys.txt" && \
    nix run github:nix-community/nixos-anywhere/main -- --extra-files "$root_dir" --generate-hardware-config nixos-facter ./hosts/{{host}}/facter.json --phases kexec,disko,install --kexec ./result/nixos-kexec-installer-x86_64-linux.tar.gz root@{{ip_address}} --copy-host-keys --flake .#{{host}}
    just ssh-keygen {{username}} {{ip_address}}
    ssh root@ip_address "systemctl reboot"

netboot:
    nix build -f ./lib/nix-expressions/netboot/system.nix -o /tmp/run-pixiecore
    -sudo iptables -w -I nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    -sudo iptables -w -I nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT
    sudo $(realpath /tmp/run-pixiecore)

build-deploy-iso host image block_device:
    nix build .#custom-iso
    just deploy-image {{host}} {{image}} {{block_device}}


test-iso:
    # nix build .#custom-iso
    nix run nixpkgs#qemu -- -cdrom result/iso/*.iso -m 4096 -enable-kvm -vnc :1 & \
    nix run nixpkgs#novnc -- --vnc localhost:5901 

# target is the host name, and the name of the .raw file when it's created. This builds from scratch AND tests the image.
# test-raw-image target:
#     $(nix-build ./lib/virtualization/qemu.nix)/bin/test-image ./{{target}}.raw

build-raw-image target:
    nix build .#nixosConfigurations.raw-image.config.system.build.diskoImagesScript 
    sudo ./result --build-memory 8096 --post-format-files ~/.config/sops/age/keys.txt /root/.config/sops/age/keys.txt

build-test-raw-image target:
    nix build .#nixosConfigurations.raw-image.config.system.build.diskoImagesScript 
    sudo ./result --build-memory 8096 --post-format-files ~/.config/sops/age/keys.txt /root/.config/sops/age/keys.txt
    $(nix-build ./lib/virtualization/qemu.nix)/bin/test-image ./{{target}}.raw


[private]
ssh-keygen username ip_address:
    # Generate SSH key (only if doesn't exist)
    ssh {{username}}@{{ip_address}} "test -f /home/{{username}}/.ssh/id_ed25519 || ssh-keygen -t ed25519 -b 4096 -C '{{ip_address}} key, danielgomezcoder@gmail.com' -f /home/{{username}}/.ssh/id_ed25519 -N ''"
    # Copy the public key to local authorized_keys (avoid duplicates)
    ssh {{username}}@{{ip_address}} "cat /home/daniel/.ssh/id_ed25519.pub" >> ~/.ssh/authorized_keys

deploy-image host image block_device:
    ssh \
    -c aes128-gcm@openssh.com \
    -o Compression=no \
    root@{{host}} \
    "dd conv=fsync oflag=direct bs=10M status=progress of={{block_device}}" < {{image}} #  equivalent do: dd if=/dev/stdin of=/dev/sda

# To test my nix-darwin machine:
# nix eval ".#darwinConfigurations.workLaptop.config.system.build.toplevel.drvPath"
# nix eval ".#darwinConfigurations.workLaptop"


# #
# Tinkering
# #

# view metadata of a github flake
# just metadata 'github:nix-community/stylix'
metadata target:
    nix flake metadata '{{target}}'

# doesn't work? Trying to show closure size..
path-info target:
    nix path-info -Sh .#nixosConfigurations.{{target}}.config.system.build.toplevel

# Shows closure size
show-closure-size target:
    nix build --no-link --print-out-paths .#nixosConfigurations.{{target}}.config.system.build.toplevel \
    | xargs nix path-info --closure-size --human-readable 

show-package-size target:
    nix path-info --closure-size --human-readable "$(nix eval --raw nixpkgs#{{target}}.outPath)"

# show-flake-size target:
#     nix path-info --closure-size --human-readable "$(nix eval github:{{target}} --raw)" \
#     | xargs nix path-info --closure-size --human-readable 

# TODO: learn how this code works
build-derivation derivation-file:
    nix-build -E 'with import <nixpkgs> {}; callPackage {{derivation-file}} {}'


