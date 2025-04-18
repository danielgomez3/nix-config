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
    
    
apply target=(host):  # both the hostname and your argument are processed
    @-just _update_secrets
    @-git add --all; \
    msg_default="{{msg_default}}"; \
    git commit -m "$msg_default"; \
    nix run github:serokell/deploy-rs -- ".#{{target}}" && \
    read -p "(optional) Enter commit msg: " msg_default ; \
    msg_default="${msg_default:-"{{msg_success}} {{target}}"}"; \
    git commit --amend -m "$msg_default"

# Validates syntax and module structure, no build or result.
eval target=(host):
    nix eval ".#nixosConfigurations.{{target}}.config.system.build.toplevel.drvPath"

# Same as eval, but for all configurations
check:
    nix flake check 

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
    nix repl --expr "builtins.getFlake \"$PWD\""


debug $RUST_BACKTRACE="1":
    just build

debug-with-repl:
    export NIX_PATH=nixpkgs=flake:nixpkgs && colmena repl


repl-flake:
    cd {{invocation_directory()}}; nix repl --extra-experimental-features 'flakes' --expr "import \"{{justfile_directory()}}/testing/learning-testing-examples/withSelf.nix\""

[confirm("Are you sure you want to potentially erase target machine's disk and deploy?")]
deploy host ip_address:
    nix run github:nix-community/nixos-anywhere -- --extra-files ~/.config/sops/age --generate-hardware-config nixos-generate-config ./hosts/{{host}}/hardware-configuration.nix root@{{ip_address}} --flake .#{{host}}

netboot:
    nix build -f ./lib/nix-expressions/netboot/system.nix -o /tmp/run-pixiecore
    -sudo iptables -w -I nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
    -sudo iptables -w -I nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT
    sudo $(realpath /tmp/run-pixiecore)
