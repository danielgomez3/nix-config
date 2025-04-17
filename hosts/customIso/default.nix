{config, pkgs, lib, modulesPath, ...}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  # configure proprietary drivers
  nixpkgs.config.allowUnfree = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
  # programs that should be available in the installer
  environment.systemPackages = with pkgs; [
    unixtools.fdisk
    git vim
  ];
}
