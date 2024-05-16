# desktop.nix
# NOTE: This contains all common features I want only my desktop to have!

{ config, pkgs, lib, inputs, modulesPath, username, host, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # ./configuration.nix
      inputs.home-manager.nixosModules.default
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # NOTE: Unique configuration.nix content for desktop:
  # environment.systemPackages = with pkgs; [
  #   libsForQt5.kdenlive
  # ];
  environment.systemPackages = with pkgs; with libsForQt5; [
  vscode
  node2nix
  (kdenlive.overrideAttrs (prevAttrs: {
    nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ]) ++ [ makeBinaryWrapper ];
    postInstall = (prevAttrs.postInstall or "") + ''
      wrapProgram $out/bin/kdenlive --prefix LADSPA_PATH : ${rnnoise-plugin}/lib/ladspa
    '';
  }))
  ];

  networking.hostName = host; # Define your hostname.
  services.xserver = {
    xkb.options = "";
  };
  services = {
    openssh = {
      extraConfig = ''
      '';
    };
    syncthing = {
      guiAddress = "127.0.0.1:8385";
      settings = {
        devices = {
          "laptop" = { id = "7M2Z4CZ-I6GVKRP-LJSSMQZ-V2TB666-6Q7L4Y2-EF2CKAN-S52ZQNE-SBMILQM"; 
          autoAcceptFolders = true; 
          };
        };
        folders = {
          "crimsonvista" = {         # Name of folder in Syncthing, also the folder ID
            path = "~/Documents/crimsonvista";    # Which folder to add to Syncthing
            devices = [ "laptop" ];      # Which devices to share the folder with
        };
        # folders = {
        #   "Documents/crimsonvista" = {         # Name of folder in Syncthing, also the folder ID
        #     path = "~/Documents/crimsonl-vista";    # Which folder to add to Syncthing
        #     # devices = [ "device1" "device2" ];      # Which devices to share the folder with
        #     devices = [ "laptop" ];      # Which devices to share the folder with
        #   };
        #   "Productivity" = {         # Name of folder in Syncthing, also the folder ID
        #     path = "~/Productivity";    # Which folder to add to Syncthing
        #     devices = [ "laptop" ];      # Which devices to share the folder with
        #   };
        };
      };
    };
  };



  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ "daniel" ];
  # virtualisation.virtualbox.host.enableExtensionPack = true;  
  # virtualisation = {
  #   docker = {
  #     enable = true;
  #   }; 
  # };
  # console.font =
  #   "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  # services.xserver.dpi = 230;
  # environment.variables = {
  #   GDK_SCALE = "2";
  #   GDK_DPI_SCALE = "2";
  #   _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  #   };


  # NOTE: Unique home-manager config for desktop:
  home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      programs = with pkgs; {
        kitty = {
          font = {
            size = 11;
          };
        };
      };
    };
  };

  # NOTE: Unique hardware-configuration.nix content for laptop:
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/82be1713-5e51-42de-842b-bca7912f9218";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7C20-2361";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
