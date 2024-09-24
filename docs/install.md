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

### Create encrypted sops file now
```bash
sops secrets/secrets.yaml
```

### Legacy (FIXME)
1. From your desired machine (let's call it 'server') derive your age key from your assumed existing private ssh key:
`nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt`

1. Delete the flake's `.sops.yaml`, and recreate the file to contain the age public key found in `keys.txt`. 
```yaml
keys:
  - &server age...  # <public-key> here
creation_rules:
  - path_regex: secrets/secrets.yaml$
    key_groups:
    - age:
        - *server
```
1. Place public ssh key into flakes `secret/` directory.

1. Edit the `secret/secrets.yaml` file via command `sops secret/secrets.yaml` to contain your ssh private key
```yaml
private_keys:
    server: |
      "-----BEGIN OPENSSH PRIVATE KEY-----
      -----END OPENSSH PRIVATE KEY-----"

```
1. From the firstly created machine 'server', add any additional age key entries from other systems to `.sops.yaml` for every machine, and every time you do, use sops to rencrypt the file accordingly
`sops updatekeys secrets.yaml`.
