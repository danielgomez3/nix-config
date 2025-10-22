# #
# NOTE:
# Lines with @ supress justfile printing executed line to standard output, not supress standard output altogether.
# Lines with @- do that and run regardless of command success
# #

host := "`hostname`"
msg_default := "System build failed, commit broken!"
msg_build := "No commit message given, building system, commit possibly broken!"
msg_success := "Successful system build and/or apply to targets:" 

[confirm("This will possibly break configuration, do not use lightly.. (y/n)")]
update:
  nix flake update
  nix flake lock

_update_secrets:
    @nix flake update mysecrets

[confirm("WARNING: commiting without testing. Not a good idea. Continue?")]
commit:
    @read -p "(optional) Amend commit msg: " amended_msg ; \
    amended_msg=${msg:-"{{msg_success}}"}; \
    git add --all; \
    git commit --amend -m "$amended_msg"
    
    
# target examples (default: your hostname):
# desktop,server
# laptop,server,desktop
apply target=(host):
    #!/usr/bin/env bash
    just _update_secrets
    git add --all
    # nix flake check

    input="{{target}}"
    IFS=',' read -r -a devices <<< "$input"
    for i in "${devices[@]}"; do
      nix run github:serokell/deploy-rs --show-trace -- --skip-checks ".#$i"
    done




# Validates syntax and module structure, no build or result.
# TODO: make dynamic for android and darwin
eval target=(host):
    nix eval ".#nixosConfigurations.{{target}}.config.system.build.toplevel.drvPath"

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


repl-flake:
    cd {{invocation_directory()}}; nix repl --extra-experimental-features 'flakes' --expr "import \"{{justfile_directory()}}/testing/learning-testing-examples/withSelf.nix\""

[confirm("Are you sure you want to potentially erase target machine's disk and deploy?")]
deploy host ip_address:
    root_dir=$(mktemp -d) && \
    trap 'rm -rf "$root_dir"' EXIT && \
    mkdir -p "${root_dir}/root/.config/sops/age" && \
    cp ~/.config/sops/age/keys.txt "${root_dir}/root/.config/sops/age/keys.txt" && \
    nix run github:nix-community/nixos-anywhere -- --extra-files "$root_dir" --generate-hardware-config nixos-generate-config ./hosts/{{host}}/hardware-configuration.nix root@{{ip_address}} --flake .#{{host}}

netboot:
    nix build -f ./lib/nix-expressions/netboot/system.nix -o /tmp/run-pixiecore
    -sudo iptables -w -I nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    -sudo iptables -w -I nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT
    sudo $(realpath /tmp/run-pixiecore)


# To test my nix-darwin machine:
# nix eval ".#darwinConfigurations.workLaptop.config.system.build.toplevel.drvPath"
# nix eval ".#darwinConfigurations.workLaptop"
