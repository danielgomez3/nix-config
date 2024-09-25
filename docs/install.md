# Install 

## Installing the flake

<!-- TODO not done -->
- To switch configurations, at any time, after this is cloned:
```nix
sudo nixos-rebuild switch --flake .#laptop
# OR whatever you decide! Make sure it points to the nix.flake:
sudo nixos-rebuild switch --flake .#raspberry-pi
```

## Creating Keys

### Standalone dev access key

1. Generate key
```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
age-keygen -y ~/.config/sops/age/keys.txt  # Print it out if you missed it!
```

1. Add the public key to our flakes .sops.yaml. This key will be the key used to encrypt the secrets.yaml file:
```yaml
keys: 
  - &daniel_gomez age ...
creation_rules:
  - path_regex: secrets/secrets.yaml$
    key_groups:
    - age:
        - *daniel_gomez

```

### System Key


1. Generate the key: `sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''`
1. Add an entry in .sops.yaml 
```yaml
keys:
  - &users:
    - &daniel_gomez: age..
  - &hosts:
    - &server age..
creation_rules:
  - path_regex: secrets/secrets.yaml$
    key_groups:
    - age:
        - *daniel_gomez
```

### Create encrypted sops file with secrets
```bash
sops secrets/secrets.yaml
```

### Create ssh key for remotely accessing your specific host

`ssh-keygen -t ed25519`  
