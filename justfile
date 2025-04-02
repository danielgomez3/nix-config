host := "`hostname`"
msg_default := "No commit message given, commit possibly broken!"
msg_success := "Successful system build and applly!"

[confirm("This will possibly break configuration, do not use lightly.. (y/n)")]
update:
  nix flake update
  nix flake lock

_update_secrets:
    @-nix flake update mysecrets

[confirm("Ammend git message? (default is 'No') ")]
_ammend_commit:
    @read -p "(optional) Amend commit msg: " amended_msg ; \
    amended_msg=${msg:-"{{msg_default}}"}; \
    git add --all; \
    git commit --amend -m "$amended_msg"
    
    
apply target=(host):
    just _update_secrets
    @read -p "(optional) Enter commit msg: " msg_possible_success ; \
    msg_default="${msg_possible_success:-"{{msg_success}}"}"; \
    git add --all; \
    git commit -m "$msg_default"
    @colmena apply --on @{{target}}
    just _ammend_commit













# #
# NOTE: Extra recipes
# #    

garbage:
    nix-collect-garbage -d --delete-older-than 5d   

# NOTE: You can run this in any directory with the desired .nix file(s) in the invocation dir.
repl:
    # nix repl --file ./lib/nix-expressions/learning-testing-examples/helpers.nix
    cd {{invocation_directory()}}; nix repl --extra-experimental-features 'flakes' --file {{justfile_directory()}}/testing/learning-testing-examples/helpers.nix

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
