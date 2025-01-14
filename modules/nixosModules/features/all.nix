# configuration.nix
# NOTE: Ubiquitous configuration.nix and home-manager content for all systems:

# Edit this configuration file tco define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ self, config, pkgs, lib, inputs,  name, ... }:
let 
  # nvChad = import ./derivations/nvchad.nix { inherit pkgs; };
  # cutefetch = import ./derivations/cutefetch.nix { inherit pkgs; };  # FIX attempting w/home-manager
  username = config.myVars.username;
in
{

  # A custom 'service' called 'all'. If a system has this enabled, it will inherit the following settings!:

    swapDevices = [{
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }];
    nixpkgs.config.allowUnfree = true;
    # nix.settings = {
    #   substituters. ["https://hyprland.cachix.org"];
    #   trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    # };
    stylix = {
      enable = true;
      # TODO: Maybe make a new dir? Or maybe make this path more pure with a variable.
      image = "${self.outPath}/modules/nixosModules/additional/wallpapers/white.jpg";
      # image = ../additional/wallpapers/white.jpg;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox.yaml";
      # cursor = { 
      #   package = pkgs.bibata-cursors; 
      #   name = "Bibata-Modern-Ice";
      #   # size = 50;
      # };
      # targets.nixvim.enable = false;
      # fonts = {
      #   monospace = {
      #     package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
      #     name = "JetBrainsMono Nerd Font Mono";
      #   };
      #   sansSerif = {
      #     package = pkgs.dejavu_fonts;
      #     name = "DejaVu Sans";
      #   };
      #   serif = {
      #     package = pkgs.dejavu_fonts;
      #     name = "DejaVu Serif";
      #   };
      # };
      # targets = {
      #   helix.enable = true;
      #   sway.enable = true;
      #   swaylock.enable = true;
      #   wezterm.enable = true;
      # };
    };

    # https://wiki.nixos.org/wiki/Syncthing#tips
    # Don't create default ~/Sync folder
    systemd.services = {
      syncthing.environment.STNODEFAULTFOLDER = "true";  
    };

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 3;
    };


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
      tailscale = {
        enable = true;
        # authKeyFile = config.sops.secrets.tailscale.path;
      };
      openssh = {
        enable = true;
        # hostKeys = [
        #   {
        #     # XXX: No longer needed? Just generate a root user key and copy it over to /etc/ssh. Or what is done here: maybe you could set the path to /root/.ssh/id_ed25519 then copy that over.
        #     comment = "to be copied over to /etc/ssh/";
        #     path = "/etc/ssh/ssh_host_ed25519_key";
        #     # path = "/root/.ssh/id_ed25519";
        #     type = "ed25519";
        #   }
        # ];
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          X11Forwarding = true;
          # PermitRootLogin = "yes";        # Allow root login with password
        };
      };
      syncthing = {
        enable = false;
        user = username;
        key = config.sops.secrets."syncthing/${name}/key_pem".path;
        cert = config.sops.secrets."syncthing/${name}/cert_pem".path;
        # dataDir = "/home/${username}/.config/data";
        # configDir = "/home/${username}/.config/syncthing";  # Folder for Syncthing's settings and keys
        overrideDevices = true;     # overrides any devices added or deleted through the WebUI
        overrideFolders = true;     # overrides any folders added or deleted through the WebUI
        settings = {
          options.urAccepted = -1;
        };
        settings = {
          devices = {
            "desktop" = { 
              id = "WCI6FZO-QIWS4TH-IHIQIVM-O7QUE4O-DT2L4JM-BCCXKNM-FOSYHFB-BZSKNQW"; 
              autoAcceptFolders = true;
            };
            "phone" = { 
              id = "TSV6QDP-T6LBRW4-XKE6S2R-ETAYRSU-B2WHSCK-P3R62AX-3KZDTW4-GWSCZA2"; 
              autoAcceptFolders = true;
            };
            "server" = { 
              id = "WDBCNRM-YJOKGOJ-FMABWTI-4UNDU2P-SKR3VP7-TEWBA3M-NKCT65Y-JHMVKQ3"; 
              autoAcceptFolders = true;
            };
            "laptop" = { 
              id = "KENW57K-IHEFCFB-36STV55-62K3EMI-AX5HGSV-IKHWLX3-MULG6CZ-6DIEZAS"; 
              autoAcceptFolders = true;
            };
          };
          folders = {
            "Documents" = {         # Name of folder in Syncthing, also the folder ID
              path = "/home/${username}/Documents";    # Which folder to add to Syncthing
              devices = [ "desktop" "server" "laptop" ];      # Which devices to share the folder with
              autoAccept = true;
              id = "Documents";
            };
            "Productivity" = {
              path = "/home/${username}/Documents/productivity";
              devices = [ "desktop" "server" "laptop" "phone" ];
              autoAccept = true;
              id = "Productivity";
            };
            "Projects" = {
              path = "/home/${username}/Projects";
              devices = [ "desktop" "server" "laptop" ];
              autoAccept = true;
              id = "Projects";
            };
          };
        };
      };
    };


    users = {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      mutableUsers = false;  # Required for a password 'passwd' to be set via sops during system activation (over anything done imperatively)!
      users.root = {
        hashedPasswordFile = config.sops.secrets.user_password.path;  
        openssh.authorizedKeys.keys = [
          (builtins.readFile "${self.outPath}/hosts/desktop/key.pub")
          (builtins.readFile "${self.outPath}/hosts/server/key.pub")
          (builtins.readFile "${self.outPath}/hosts/laptop/key.pub")
        ];
      };

      users.${username} = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.user_password.path;  # Shoutout to sops baby.
        # password = "123";
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        # FIXME: relative imports
        openssh.authorizedKeys.keys = [
          # Needed for personal use, to ssh and do some normal user work.
          (builtins.readFile "${self.outPath}/hosts/desktop/key.pub")
          (builtins.readFile "${self.outPath}/hosts/server/key.pub")
          (builtins.readFile "${self.outPath}/hosts/laptop/key.pub")
          # Needed for Colmena b/c doesn't use root for colmena?
          (builtins.readFile "${self.outPath}/hosts/desktop/root-key.pub")
          (builtins.readFile "${self.outPath}/hosts/laptop/root-key.pub")
          (builtins.readFile "${self.outPath}/hosts/server/root-key.pub")
        ];
      };
    };
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment = {
      # sessionVariables = {
      #   GITHUB_TOKEN = config.sops.secrets.github_token.path;  
      #   GITHUB_TOKEN = "$(cat ${config.sops.secrets.github_token.path})";
      # };
      systemPackages = with pkgs; [
        # linux linux-firmware
        git wget curl pigz 
        lm_sensors 
        woeusb ntfs3g 
        iptables nftables file toybox 
        waypipe # x11 forwarding alternative:
        # Security
        gnupg pinentry-tty age yubioath-flutter yubikey-manager pam_u2f
      ];
    };

    # Yubikey required services and config.
    # services.udev.packages = [ pkgs.yubikey-personalization ];

    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # services.pcscd.enable = true;
    # services.udev.packages = [ pkgs.yubikey-personalization ];
    # services.yubikey-agent.enable = true;
    # security.pam = {
    #   sshAgentAuth.enable = true;
    #   u2f = {
    #     enable = true;
    #     settings = {
    #       cue = true;
    #       authFile = "/home/${username}/.config/Yubico/u2f_keys";
    #     };
    #   };
    #   services = {
    #     login.u2fAuth = true;
    #     sudo = {
    #       u2fAuth = true;
    #       sshAgentAuth = true; # Use SSH_AUTH_SOCK for sudo
    #     };
    #   };
    # };



    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?

    nix.settings.experimental-features = [ "nix-command" "flakes" ];





  
}
