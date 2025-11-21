{
  pkgs,
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = ["${modulesPath}/profiles/qemu-guest.nix"];
  # services.qemuGuest.enable = true;

  boot.loader.grub.efiSupport = lib.mkDefault true;
  boot.loader.grub.efiInstallAsRemovable = lib.mkDefault true;

  # Adjust this to your liking.
  # WARNING: if you set a too low value the image might be not big enough to contain the nixos installation
  disko.devices.disk.main.imageSize = "20G";

  disko.devices.disk.main.imageName = "raw-image"; # NOTE setting is unique to .raw image hosts

  # FIXME: raw image won't boot, undless I import qemu-guest.nix:
}
