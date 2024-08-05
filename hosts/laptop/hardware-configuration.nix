# NOTE: Unique hardware-configuration.nix content for Laptop:

{ config, lib, modulesPath, ... }:

{
  imports =
    [ 
      # /etc/nixos/hardware-configuration.nix
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "uas" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f1faf40b-755e-4d2c-80fe-1f3b45c4643b";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-1bbabfb2-7b1e-4753-9058-e31c5dc3253e".device = "/dev/disk/by-uuid/1bbabfb2-7b1e-4753-9058-e31c5dc3253e";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/55AB-2836";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/2cae7e3b-9657-4ee2-a029-181ba12d0b87"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}


