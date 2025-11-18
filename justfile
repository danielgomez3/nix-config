# #
# NOTE:
# Lines with @ supress justfile printing executed line to standard output, not supress standard output altogether.
# Lines with @- do that and run regardless of command success
# #

host := "`hostname`"
msg_default := "System build failed, commit broken!"
msg_build := "No commit message given, building system, commit possibly broken!"
msg_success := "Successful system build and/or apply to targets:" 
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
apply-remote:
    nohup for i in {server,test-machine,nas-server,llm-machine,living-room}; do just deploy-rs "$i"; done > /var/log/just-apply-remote.log
    

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
    nixos-rebuild build --flake ".#{{target}}" 
    

    




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

[confirm("This might potentially erase a directory/host with the same name. Continue?")]
new host username block_device description:
    [ ! -d "./hosts/{{host}}" ] && scp -r ./lib/deployment/templateHost ./hosts/{{host}} || false
    sed -i -E 's/\bxxusernamexx\b/{{username}}/g' ./hosts/{{host}}/*.nix
    sed -i -E 's/\bxxhostnamexx\b/{{host}}/g' ./hosts/{{host}}/*.nix
    sed -i -E 's/\bxxdescriptionxx\b/{{description}}/g' ./hosts/{{host}}/*.nix
    sed -i -E 's|\bxxblock_devicexx\b|{{block_device}}|g' ./hosts/{{host}}/*.nix
    git add -A :/

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

test-iso:
    nix build .#custom-iso
    nix run nixpkgs#qemu -- -cdrom result/iso/*.iso -m 4096 -enable-kvm -vnc :1 && \
    nix run nixpkgs#novnc -- --vnc localhost:5901 

[private]
ssh-keygen username ip_address:
    # Generate SSH key (only if doesn't exist)
    ssh {{username}}@{{ip_address}} "test -f /home/{{username}}/.ssh/id_ed25519 || ssh-keygen -t ed25519 -b 4096 -C '{{ip_address}} key, danielgomezcoder@gmail.com' -f /home/{{username}}/.ssh/id_ed25519 -N ''"
    # Copy the public key to local authorized_keys (avoid duplicates)
    ssh {{username}}@{{ip_address}} "cat /home/daniel/.ssh/id_ed25519.pub" >> ~/.ssh/authorized_keys

# deploy-iso host block_device:
#     ssh root@{{host}} "dd conv=fsync oflag=direct bs=8M status=progress of={{block_device}}" < {{iso}} #  equivalent do: dd if=/dev/stdin of=/dev/sda

# To test my nix-darwin machine:
# nix eval ".#darwinConfigurations.workLaptop.config.system.build.toplevel.drvPath"
# nix eval ".#darwinConfigurations.workLaptop"
