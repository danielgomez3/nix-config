{ config, inputs, lib, pkgs, ... }:

let
  sys = inputs.nixos.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ({ config, pkgs, lib, modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/netboot/netboot-minimal.nix") ];
        config = {
          services.openssh = {
            enable = true;
            openFirewall = true;

            settings = {
              PasswordAuthentication = false;
              KbdInteractiveAuthentication = false;
            };
          };

        };
      })
    ];
  };

  build = sys.config.system.build;
in {
  services.pixiecore = {
    enable = true;
    openFirewall = true;
    dhcpNoBind = true; # Use existing DHCP server.

    mode = "boot";
    kernel = "${build.kernel}/bzImage";
    initrd = "${build.netbootRamdisk}/initrd";
    cmdLine = "init=${build.toplevel}/init loglevel=4";
    debug = true;
  };
}

