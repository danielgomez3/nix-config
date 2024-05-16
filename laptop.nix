# laptop.nix
# NOTE: This contains all common features I want only my laptop to have!

{ config, pkgs, lib, inputs, modulesPath, username, host, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # ./configuration.nix
      inputs.home-manager.nixosModules.default
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

 # NOTE: Unique configuration.nix content for desktop:
  networking.hostName = host; # Define your hostname.
  services = {
    syncthing = {
      guiAddress = "127.0.0.1:8383";
  #     settings = {
  #       devices = {
  #         "desktop" = { id = "SVUBZNU-A4HDWGG-AC7MPHA-GFHE5HD-XUJ6VIK-63SO7RQ-DTR3ECT-ATGF3QI"; autoAcceptFolders = true;};
  #       };
  #     };
    };
  };

  services.xserver = {
   # enable = true;
   xkb.options = "caps:swapescape";
  };


  # NOTE: Unique home-manager config for laptop:
  home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      programs = with pkgs; {
        kitty = {
          font = {
            size = 14;
          };
        };
      };
    };
  };


  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1a48a33e-17b5-4a52-b5c6-819cc2d0ccd5";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-2dade71e-8c5e-4bfd-b16e-a72861e74693".device = "/dev/disk/by-uuid/2dade71e-8c5e-4bfd-b16e-a72861e74693";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4F44-CF68";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ff70bf2f-9b69-494d-aca4-eeda40f56bba"; }
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
