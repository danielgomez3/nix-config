# configuration.nix
# NOTE: Ubiquitous configuration.nix and home-manager content for all systems:

# Edit this configuration file tco define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, host, username, ... }:
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

  nixpkgs.config.allowUnfree = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    hostName = host;  # Define your hostname.
    dhcpcd.enable = true;
    domain = "home";
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
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        # PermitRootLogin = "yes";        # Allow root login with password
      };
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
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9OcZ6CO1lDXOMQQawee8Fh6iydI8I+SXMdD9GESq8v daniel@desktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHdnOQw9c23oUEIBdZFrKb/r4lHIKLZ9Dz11Un0erVsj danielgomez3@server"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git wget curl pigz helix
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
  home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      home = {
        stateVersion = "24.05";
        packages = with pkgs; [
          iptables dmidecode 
          eza entr tldr bc tree trash-cli 
        ];
      };

    programs = {
      bash = {
        enable = true;
        enableCompletion = true;
        bashrcExtra = ''
          export HISTCONTROL=ignoreboth:erasedups
          shopt -s autocd cdspell globstar extglob nocaseglob
          # 1 tab autocomplete:
          bind 'set show-all-if-ambiguous on'
          bind 'set completion-ignore-case on'

          c() { z "$@" && eza --icons --color=always --group-directories-first; }
          #e() { [ $# -eq 0 ] && hx . || hx "$@"; }
          e() { if [ $# -eq 0 ]; then hx .; else hx "$@"; fi; }
        '';
        shellAliases = {
          f = "fg";
          j = "jobs";
          l = "eza --icons --color=always --group-directories-first";
          la = "eza -a --icons --color=always --group-directories-first";
          lt = "eza --icons --color=always --tree --level 2 --group-directories-first";
          lta = "eza -a --icons --color=always --tree --level 2 --group-directories-first";
          grep = "grep --color=always -IrnE --exclude-dir='.*'";
          less = "less -FR";
          rm = "trash-put";
        };
      };

      git = {
        enable = true;
        userName = "danielgomez3";
        userEmail = "danielgomez3@verizon.net";
        extraConfig = {
          credential.helper = "store";
          # url = {
          #   "https://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@github.com/" = {
          #     insteadOf = "https://github.com/";
          #   };
          # };
        };
      };


        # TODO: Make a <leader>/ function that will search fuzzily. Every space will interpret '.*'
    ssh = {
      enable = true;
      extraConfig = ''
        Host vps
           HostName 46.226.105.34
           User root
           IdentityFile ~/.ssh/id_ed25519

      '';
    };
  };
    };
  };
}
