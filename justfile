default:
    @just --list

keep-going:
    echo "The way out is through"

update-nix-secrets:
    (cd ../nix-secrets && git fetch && git rebase) || true
    nix flake lock --update-input nix-secrets

check-sops:
    scripts/check-sops.sh

rebuild-pre:
    just update-nix-secrets
    git add *.nix

rebuild-post:
    just check-sops

rebuild:
    just rebuild-pre
    scripts/system-flake-rebuild.sh

rebuild-full:
    just rebuild-pre
    scripts/system-flake-rebuild.sh
    just rebuild-post

update:
    nix flake update
