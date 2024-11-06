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
          users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEcgBEJP6HLTNXKHaiTmWdCM/edgUhTZqIPsuITlbe9M root@nixos"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJW8ix2afb5YJQiWw2sDJVPV+gfcPo+WexSodqfUCUzu daniel@desktop"
          ];



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
