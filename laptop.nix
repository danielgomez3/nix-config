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
      enable = true;
      user = username;
      dataDir = "/home/daniel/";
      configDir = "/home/daniel/.config/syncthing";
      settings = {
        devices = {
          "desktop" = { id = "AVLUKCW-YQFFBN6-VLK4WIO-3WSRN6D-LJSVRRE-YZYSF6Z-J5RV2JD-MOYEUAN"; autoAcceptFolders = true;};
        };
      };
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


  # NOTE: Unique hardware-configuration.nix content for laptop:
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/859d7abd-a8d0-47cb-9641-cee376ae2847";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/18EF-0255";
      fsType = "vfat";
    };

  swapDevices = [ ];

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
