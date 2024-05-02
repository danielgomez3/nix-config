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
        folders = {
          "nixos" = {
            path = "/etc/nixos/";
            devices = [ "laptop" ];
            ignorePerms = true;  # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          };
          ".when" = {
            path = "~/.when/";
            devices = [ "laptop" ];
          };
          # "Documents" = {         # Name of folder in Syncthing, also the folder ID
          #   path = "~/Documents";    # Which folder to add to Syncthing
          #   # devices = [ "device1" "device2" ];      # Which devices to share the folder with
          #   devices = [ "laptop" ];      # Which devices to share the folder with
          # };
          "Documents/pdfs" = {         # Name of folder in Syncthing, also the folder ID
            path = "~/Documents/pdfs";    # Which folder to add to Syncthing
            # devices = [ "device1" "device2" ];      # Which devices to share the folder with
            devices = [ "laptop" ];      # Which devices to share the folder with
          };
          "Documents/misc" = {         # Name of folder in Syncthing, also the folder ID
            path = "~/Documents/misc";    # Which folder to add to Syncthing
            # devices = [ "device1" "device2" ];      # Which devices to share the folder with
            devices = [ "laptop" ];      # Which devices to share the folder with
          };
          "Documents/personal-info" = {         # Name of folder in Syncthing, also the folder ID
            path = "~/Documents/personal-info";    # Which folder to add to Syncthing
            # devices = [ "device1" "device2" ];      # Which devices to share the folder with
            devices = [ "laptop" ];      # Which devices to share the folder with
          };
          "Productivity" = {         # Name of folder in Syncthing, also the folder ID
            path = "~/Productivity";    # Which folder to add to Syncthing
            devices = [ "laptop" "phone" ];      # Which devices to share the folder with
          };
          # "Projects/repos/repos-learning/learning-haskell" = {         # Name of folder in Syncthing, also the folder ID
          #   path = "~/Projects/repos/repos-learning/learning-haskell/";    # Which folder to add to Syncthing
          #   devices = [ "laptop" ];      # Which devices to share the folder with
          # };
          "Projects/repos-learning/learning-haskell" = {         # Name of folder in Syncthing, also the folder ID
            path = "~/Projects/repos/repos-learning/learning-haskell/";    # Which folder to add to Syncthing
            devices = [ "laptop" ];      # Which devices to share the folder with
          };
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
    { device = "/dev/disk/by-uuid/4f78ca2d-fe56-401e-88b4-50b0b8920dd8";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/36D8-403D";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
