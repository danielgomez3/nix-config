- Create an automated install process with nixos-anywhere and disko.
- Make sops nix hide ssh user alias in `all.nix`.


Here is a problem I have explained in great detail. I, from my desktop, a nixos machine, will netboot an image to my laptop following the official wiki. I'm successful! Here are the instructions I follow:

```
# Build pixiecore runner
nix build -f system.nix -o /tmp/run-pixiecore

# Open required firewall ports
sudo iptables -w -I nixos-fw -p udp -m multiport --dports 67,69,4011 -j ACCEPT
sudo iptables -w -I nixos-fw -p tcp -m tcp --dport 64172 -j ACCEPT

# Run pixiecore
sudo $(realpath /tmp/run-pixiecore)
```

When I netboot, I can ssh into my laptop successfully. The problem is, when I want to use nixos-anywhere to deploy my flake (which is properly configured in my flake, no errors), I'll run it like so:

`nix run github:nix-community/nixos-anywhere -- --flake <path to configuration>#<configuration name> root@<ip address>`

It will rebuild the system, shut it down, and reboot completely in a new installer image.. This seems weird. Because then, in order to deploy my flake successfully, I have to run this command once again on the rebooted system (which would have also changed IPs because of DDHCP):

`nix run github:nix-community/nixos-anywhere -- --flake <path to configuration>#<configuration name> root@<ip address>`

Why is this the case? Is this undesired behavior? Is this normal? Why do I have to run this command twice? And why does it shut down mid install just to boot into an installer image? I guess the pxe boot environment might not be a valid installer environment or something..

Here is the netboot `system.nix` that I'm using, as described in the wiki:

```
let
  # NixOS 22.11 as of 2023-01-12
  nixpkgs = builtins.getFlake "github:nixos/nixpkgs/54644f409ab471e87014bb305eac8c50190bcf48";

  sys = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ({ config, pkgs, lib, modulesPath, ... }: {
        imports = [
          (modulesPath + "/installer/netboot/netboot-minimal.nix")
        ];
        config = {
          ## Some useful options for setting up a new system
          # services.getty.autologinUser = lib.mkForce "root";
          # users.users.root.openssh.authorizedKeys.keys = [ ... ];
          # console.keyMap = "de";
          # hardware.video.hidpi.enable = true;

          system.stateVersion = config.system.nixos.release;
        };
      })
    ];
  };

  run-pixiecore = let
    hostPkgs = if sys.pkgs.system == builtins.currentSystem
               then sys.pkgs
               else nixpkgs.legacyPackages.${builtins.currentSystem};
    build = sys.config.system.build;
  in hostPkgs.writers.writeBash "run-pixiecore" ''
    exec ${hostPkgs.pixiecore}/bin/pixiecore \
      boot ${build.kernel}/bzImage ${build.netbootRamdisk}/initrd \
      --cmdline "init=${build.toplevel}/init loglevel=4" \
      --debug --dhcp-no-bind \
      --port 64172 --status-port 64172 "$@"
  '';
in
  run-pixiecore
```

  
