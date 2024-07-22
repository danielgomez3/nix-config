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
          users.users.root.openssh.authorizedKeys.keys = [ 
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmbQTmXq4zFi8xxkHVGcWg63Vbs3RwsUMaXZCyB4+s4fkxkCkz2py3LrK2x0JcVvqUKpaIRuxt36TCA+jxVtIJJWowHR/0yCj/KH5htyvKvY+IxkYniOcSRVZ6oYkTKVQR+ExGeziCptsRSRTKlb7cAD1a8VdFR49/3VR5o0Mbo9brzaEpW+aAnX8cSV9sVxLSIBZe7VLCaiTToN1bhYKebHQcBVKYOvptIFDl3r8qW/A8Ej7JvV9/CjrqKz5Ntc527H6f98V3UrtfY/kRDnpngdZIXGwVC2vlShquzB7OJLsiuRhs/XY6BvuZuGlSwsMD8nRSXyFDnLNec8suWf8d2ijcj4uXhKRmVhsSJ1hrTMByyC6LEImzC4QO7gXHNJ4XSBdnIXmGNDCggrAniyzhlVP85MiOh9Yi7x5fAqwZCE0N+Nl+Sf3yGEinzN3qDUIUUMJmgvxljPejSlTRbNSkZZMUQGajSGykautcK4kup+NTGbmju9Nx3BqyZIY14fMbKjIFRdQzzRMQ2rnrXkkNIidW5UozUKoPZG79RVZBdbCbZhEHcFSwK0fuvmTxngL7Y+A7NGilqupFDrXWknS6Fn/XPPBaPHjwyJDsZMPq9OZd4M77JVlJm8KeBRxY5cQDLzSylgkjgGiyEBwvAqJRItxsy4g3C70LKttmrAYatw== daniel@desktopssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmbQTmXq4zFi8xxkHVGcWg63Vbs3RwsUMaXZCyB4+s4fkxkCkz2py3LrK2x0JcVvqUKpaIRuxt36TCA+jxVtIJJWowHR/0yCj/KH5htyvKvY+IxkYniOcSRVZ6oYkTKVQR+ExGeziCptsRSRTKlb7cAD1a8VdFR49/3VR5o0Mbo9brzaEpW+aAnX8cSV9sVxLSIBZe7VLCaiTToN1bhYKebHQcBVKYOvptIFDl3r8qW/A8Ej7JvV9/CjrqKz5Ntc527H6f98V3UrtfY/kRDnpngdZIXGwVC2vlShquzB7OJLsiuRhs/XY6BvuZuGlSwsMD8nRSXyFDnLNec8suWf8d2ijcj4uXhKRmVhsSJ1hrTMByyC6LEImzC4QO7gXHNJ4XSBdnIXmGNDCggrAniyzhlVP85MiOh9Yi7x5fAqwZCE0N+Nl+Sf3yGEinzN3qDUIUUMJmgvxljPejSlTRbNSkZZMUQGajSGykautcK4kup+NTGbmju9Nx3BqyZIY14fMbKjIFRdQzzRMQ2rnrXkkNIidW5UozUKoPZG79RVZBdbCbZhEHcFSwK0fuvmTxngL7Y+A7NGilqupFDrXWknS6Fn/XPPBaPHjwyJDsZMPq9OZd4M77JVlJm8KeBRxY5cQDLzSylgkjgGiyEBwvAqJRItxsy4g3C70LKttmrAYatw== daniel@desktop"
          ];
          # console.keyMap = "de";
          # hardware.video.hidpi.enable = true;

          system.stateVersion = config.system.nixos.release;

          services.openssh = {
            enable = true;
            passwordAuthentication = false;
            # extraConfig = ''
            #   PasswordAuthentication no
            #   ChallengeResponseAuthentication no
            #   PubkeyAuthentication no
            #   AuthenticationMethods none
            # '';
          };
        };
      environment.systemPackages = with pkgs; [
        helix vim git curl iptables dmidecode 
      ];
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
