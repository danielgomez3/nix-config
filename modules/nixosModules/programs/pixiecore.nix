{ config, pkgs, lib, ... }:

let
  # Define the system closure path
  systemClosure = "/nix/store/i48drjmzl8d9a1p0gv4b0003g5bsqxzk-nixos-system-laptop-24.11pre-git";
in {
  services.pixiecore.enable = true;
  services.pixiecore.mode = "boot";  # Boot mode without provisioning
  services.pixiecore.kernel = "${systemClosure}/kernel";  # Use the kernel from your system closure
  services.pixiecore.initrd = [ "${systemClosure}/initrd" ];  # Provide the initrd
  # services.pixiecore.cmdline = "init=${systemClosure}/init boot.shell_on_fail";  # Use system init

  networking.firewall.allowedTCPPorts = [ 67 69 4011 ];  # PXE standard ports
}

