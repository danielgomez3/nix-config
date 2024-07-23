# laptop.nix
# NOTE: This contains all common features I want only my laptop to have!

{ config, pkgs, lib, inputs, modulesPath, username, host, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./configurations/all.nix
      ./configurations/gui.nix
      ./configurations/coding.nix
      # /etc/nixos/hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

 # NOTE: Unique configuration.nix content for desktop:
  users.users.${username} = {
    description = "laptop";
  };
  networking.hostName = host; # Define your hostname.
  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
      };

    };
    syncthing = {
      guiAddress = "127.0.0.1:8383";
    };
  };

  services.xserver = {
   # enable = true;
   xkb.options = "caps:swapescape";
  };


  # NOTE: Unique home-manager config for laptop:
  # home-manager = { 
  #   extraSpecialArgs = { inherit inputs; };
  #   users.${username} = {
  #     programs = with pkgs; {
  #       kitty = {
  #         font = {
  #           size = 14;
  #         };
  #       };
  #     };
  #   };
  # };


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
