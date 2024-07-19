# configuration.nix
# NOTE: Ubiquitous configuration.nix and home-manager content for all systems:

# Edit this configuration file tco define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, username, ... }:
let 
  # nvChad = import ./derivations/nvchad.nix { inherit pkgs; };
  cutefetch = import ./derivations/cutefetch.nix { inherit pkgs; };  # FIX attempting w/home-manager
in
{



  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    systemd-boot.configurationLimit = 3;
  };


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
      wireless.iwd = {
      enable = true;
      settings = {
        IPv6 = {
          Enabled = true;
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };
    dhcpcd = {
      enable = true;
    };
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ 80 5000 ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall.enable = false;
    firewall.allowedTCPPorts = [ 8384 22000 ];
    firewall.allowedUDPPorts = [ 22000 21027 ];
  };




  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


  services = { 
    openssh = {
      enable = true;
    };
    syncthing = {
      enable = true;
      user = username;
      # dataDir = "/home/${username}/Documents/";
      configDir = "/home/${username}/.config/syncthing";   # Folder for Syncthing's settings and keys
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    };
  };




  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
    openssh.authorizedKeys.keys = [ 
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCgWGU+UPFoiKMoLp7EYQacLPLT33vBdOo6O4PcCyvhb+ZxMVFBsI9nA6gJ5PxlCym1scoQe7QgYhhRxqhximKxLUQCvz0kkCkh0Q4veCVzXGuUgzQIYQkKyRQyj99RaEtb/awH9YXXJIrWnzW+WY9xdkZLnuLN4M1TA/5oVEqWvgPdjoDZVvOEHNbhxrjwnshxkRWFFNZ2HxL6ZAt27e1CFfyFmY+GyJ1YyRqqhNCD4K48oYBHsRT3B63xCvW5QfN2QLVibPGagcG0BfS8AZ4iKbJfpMw1IBw4AZFAypj0wSlGf+4nwX7NuZ10SJNXWgnGdZd07Q/PbzHKrS3l6TblfKO++M1cpGI9k77RAkpysawenVxqfM0rFXmF7GHomPndiokYUDV2xPL6cHZUYAeYM//P7GR5ZSlVbtJnvf9gyMOeEH72i2MuAp2mIrrRxjic2Yffq48C2pFB4KEyvdOwSxDGDriLy/2IwclxnVNC1CL9/DHMQMpop9bBCBfpWtFwV4N8nfFRe/B1PmQWp2hoMR2bwaGSsjw7X21J9pABBPHGTRKduX1V3g4kCurZe2TwPO7CemPvWnBn2rYXhubocFjMzZRYX9e+96Zhf4w7kY9Bqui/wrnaLWVeNfmcFgppe3rCxVra5c0kXnguxy+MyZrsPyNpG/3EuKihbdTQmw== daniel@desktop"

    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git wget curl pigz 
    lm_sensors 
    woeusb ntfs3g
  ];



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?


  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  security.sudo.wheelNeedsPassword = false;


  
}
