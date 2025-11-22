{
  pkgs,
  lib,
  config,
  modulesPath,
  ...
}: {
  boot.loader.grub.efiSupport = lib.mkDefault true;
  boot.loader.grub.efiInstallAsRemovable = lib.mkDefault true;

  # shut up state version warning
  # system.stateVersion = config.system.nixos.release;
  # Adjust this to your liking.
  # WARNING: if you set a too low value the image might be not big enough to contain the nixos installation
  disko.devices.disk.main.imageSize = "7G";
}
