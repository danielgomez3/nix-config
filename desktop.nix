# desktop.nix
# NOTE: This contains all common features I want only my desktop to have!

{ config, pkgs, lib, inputs, modulesPath, username, host, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./configuration.nix
      # /etc/nixos/hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # NOTE: Unique configuration.nix content for desktop:
  # environment.systemPackages = with pkgs; [
  #   libsForQt5.kdenlive
  # ];
  hardware.keyboard.zsa.enable = true;
  environment.systemPackages = with pkgs; with libsForQt5; [
  vscode
  node2nix
  wally-cli
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
          "laptop" = { id = "R7A34TT-T662VVH-H2CXF7L-ULKAWWZ-WIGA7LR-3JKLYTL-LSVBHAA-3I245AH"; 
          autoAcceptFolders = true; 
          };
          "phone" = {id = "L4PI6U7-VTRHUSU-WLSC3GV-EHWG4QX-DMSNSEL-DVACMSN-7D2EOIT-AIREAAZ";
          autoAcceptFolders = true; 
          };
        };
        folders = {
          "Documents/" = {         # Name of folder in Syncthing, also the folder ID
            path = "~/Documents/";    # Which folder to add to Syncthing
            devices = [ "laptop" ];      # Which devices to share the folder with
        };
          # "Documents/crimsonvista" = {         # Name of folder in Syncthing, also the folder ID
          #   path = "~/Documents/crimson-vista";    # Which folder to add to Syncthing
          #   # devices = [ "device1" "device2" ];      # Which devices to share the folder with
          #   devices = [ "laptop" ];      # Which devices to share the folder with
          # };
          "Productivity" = {         # Name of folder in Syncthing, also the folder ID
            path = "~/Productivity";    # Which folder to add to Syncthing
            devices = [ "laptop" ];      # Which devices to share the folder with
          };
          "Projects" = {         # Name of folder in Syncthing, also the folder ID
            path = "~/Projects";    # Which folder to add to Syncthing
            devices = [ "laptop" ];      # Which devices to share the folder with
          };
          "flake" = {         # Name of folder in Syncthing, also the folder ID
            path = "~/flake";    # Which folder to add to Syncthing
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
      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
        size = 24;
        x11 = {
          enable = true;
          defaultCursor = "Adwaita";
        };
      };
      programs = with pkgs; {
        kitty = {
          font = {
            size = 11;
          };
        };
      };
      wayland.windowManager.sway = {
        extraConfig = ''
        output HDMI-A-1 scale 2
        '';
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
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
