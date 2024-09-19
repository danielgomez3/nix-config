# configuration.nix
# NOTE: Ubiquitous configuration.nix and home-manager content for all systems:

# Edit this configuration file tco define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, host, username, ssh-keys, ... }:
let 
  # nvChad = import ./derivations/nvchad.nix { inherit pkgs; };
  # cutefetch = import ./derivations/cutefetch.nix { inherit pkgs; };  # FIX attempting w/home-manager
  cfg = config.services.all;
in
{

  options.services.all = {
    enable = lib.mkEnableOption "all service";
  };

  # A custom 'service' called 'all'. If a system has this enabled, it will inherit the following settings!:
  config = lib.mkIf cfg.enable {

    nixpkgs.config.allowUnfree = true;
    sops = {
      defaultSopsFile = ../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age = {
        # Automatically import host SSH keys as age keys
        sshKeyPaths = [ "/home/${username}/.ssh/id_ed25519" ];
        # Specify where it will be stored. Or this will use an age key that's expected to already be in the filesystem
        keyFile = "/home/${username}/.config/sops/age/keys.txt";
        # Generate a new key if the key specified doesn't exist in the first place:
        generateKey = true;
      };
      secrets = {
        user_password = {
          # Decrypt 'user-password' to /run/secrets-for-users/ so it can be used to create the user and assign their password without having to run 'passwd <user>' imperatively:
          neededForUsers = true;
        };
        github_token = {
          owner = config.users.users.${username}.name;
          group = config.users.users.${username}.group;
        };
        example_key = { };
        "myservice/my_subdir/my_secret" = {
          owner = config.users.users.${username}.name; # Make the token accessible to this user
          group = config.users.users.${username}.group; # Make the token accessible to this group
        };    
      };
    };

    systemd.services = {
      syncthing.environment.STNODEFAULTFOLDER = "true";  # Don't create default ~/Sync folder
      "sometestservice" = {
        script = ''
            echo "
            Hey bro! I'm a service, and imma send this secure password:
            $(cat ${config.sops.secrets."myservice/my_subdir/my_secret".path})
            located in:
            ${config.sops.secrets."myservice/my_subdir/my_secret".path}
            to database and hack the mainframe
            " > /var/lib/sometestservice/testfile
          '';
        serviceConfig = {
          User = "sometestservice";
          WorkingDirectory = "/var/lib/sometestservice";
        };
      };
    };

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 3;
    };

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
      firewall.enable = false;
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
        knownHosts = {
          "desktop" = {
            hostNames = [ "desktop" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9OcZ6CO1lDXOMQQawee8Fh6iydI8I+SXMdD9GESq8v";
          };
          "server" = {
            hostNames = [ "server" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHdnOQw9c23oUEIBdZFrKb/r4lHIKLZ9Dz11Un0erVsj";
          };
          "laptop" = {
            hostNames = [ "laptop" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ4W1AIoMxiKJQXOwJlkJkwZ0pMOe/akO86duVI/NWG";
          };
          "deploy-server" = {
            hostNames = [ "server" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEA/kfm1TYsOaPnzbLYnWixnjHSYWgYcS82z/xQGKgwb";
          };
        };
      };
      syncthing = {
        enable = true;
        user = username;
        dataDir = "/home/${username}/.config/data";
        configDir = "/home/${username}/.config/syncthing";  # Folder for Syncthing's settings and keys
        overrideDevices = true;     # overrides any devices added or deleted through the WebUI
        overrideFolders = true;     # overrides any folders added or deleted through the WebUI
        settings = {
          options.urAccepted = -1;
        };
        settings = {
          devices = {
            "desktop" = { 
              id = "S6AZSHX-D52JRH4-BZAWTPS-7LZH4MT-KTHEJK3-GXJ47AY-6ZPU2GU-PEKOXQ2"; 
              autoAcceptFolders = true;
            };
            "phone" = { 
              id = "L4PI6U7-VTRHUSU-WLSC3GV-EHWG4QX-DMSNSEL-DVACMSN-7D2EOIT-AIREAAZ"; 
              autoAcceptFolders = true;
            };
            "server" = { 
              id = "2Q5KLG2-JH7EGJS-6SSYWIL-7K43Y56-YEN524B-BX2APWC-FRJ6TRQ-2ZTSOAJ"; 
              autoAcceptFolders = true;
            };
            "laptop" = { 
              id = "N4J2FSZ-DDQTYR2-RT6FC3Q-GKVPV66-MCMP2FD-6JDYI4P-JZYQR2L-OEOKHQW"; 
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
              devices = [ "desktop" "server" "laptop" ];
              autoAccept = true;
              id = "Productivity";
            };
            "Projects" = {
              path = "/home/${username}/Projects";
              devices = [ "desktop" "server" "laptop" ];
              autoAccept = true;
              id = "Projects";
            };
            "nix" = {
              path = "/home/${username}/.config/nix/";
              devices = [ "desktop" "server" "laptop" ];
              autoAccept = true;
              id = "nix";
            };
          };
        };
      };
    };


    users = {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      mutableUsers = false;  # Required for a password 'passwd' to be set via sops during system activation (over anything done imperatively)!
      groups.sometestservice = { };
      users.sometestservice = {
        home = "/var/lib/sometestservice";
        createHome = true;
        isSystemUser = true;
        group = "sometestservice";
      };
      users.${username} = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.user_password.path;  # Shoutout to sops baby.
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        openssh.authorizedKeys.keys = ssh-keys;
      };
    };
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      git wget curl pigz vim
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
    home-manager = { 
      extraSpecialArgs = { inherit inputs; };
      users.${username} = {
        home = {
          stateVersion = "24.05";
          packages = with pkgs; [
            iptables dmidecode 
            eza entr tldr bc tree 
            # cli apps
            pciutils usbutils 
            protonvpn-cli_2 yt-dlp yt-dlp spotdl android-tools adb-sync unzip android-tools ffmpeg mpv sops
            tesseract ocrmypdf
          ];
        };

        programs = {

          starship = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
          };

          zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            history = {
              size = 10000;
            };
            initExtra = ''
              if [[ -o interactive ]]; then
                  export GITHUB_TOKEN=$(cat /run/secrets/github_token)
              fi
              export HISTCONTROL=ignoreboth:erasedups
              # 1 tab autocomplete:
              #bind 'set show-all-if-ambiguous on'
              #bind 'set completion-ignore-case on'

              c() { z "$@" && eza --icons --color=always --group-directories-first; }
              e() { if [ $# -eq 0 ]; then hx .; else hx "$@"; fi; }
              screenshot() {
                read -p "Enter filename: " filename && grim -g "$(slurp)" ./''${filename}.png
              }
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
              plan = "cd ~/Documents/productivity/ && hx planning/todo.md planning/credentials.md";
              conf = "cd ~/Projects/repos-personal/flakes/flake/ && hx modules/coding.nix modules/all.nix";
              notes = "cd ~/Documents/productivity/notes && hx .";
              zrf = "zellij run floating";
            };
          };

          bash = {
            enable = false;
            enableCompletion = true;
            bashrcExtra = ''
              export HISTCONTROL=ignoreboth:erasedups
              shopt -s autocd cdspell globstar extglob nocaseglob

              c() { z "$@" && eza --icons --color=always --group-directories-first; }
              #e() { [ $# -eq 0 ] && hx . || hx "$@"; }
              e() { if [ $# -eq 0 ]; then hx .; else hx "$@"; fi; }
              screenshot() {
                read -p "Enter filename: " filename && grim -g "$(slurp)" ./''${filename}.png
              }
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
              # rm = "${pkgs.trash-cli}/bin/trash-put";
              plan = "cd ~/Documents/productivity/ && hx planning/todo.md planning/credentials.md";
              conf = "cd ~/Projects/repos-personal/flakes/flake/ && hx modules/coding.nix modules/all.nix";
              notes = "cd ~/Documents/productivity/notes && hx .";
              zrf = "zellij run floating";
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

          ssh = {
            enable = true;
            extraConfig = ''
              Host server
                 HostName 192.168.12.149 
                 User danielgomez3

              Host deploy
                 HostName 192.168.12.149 
                 User root

              Host desktop
                 HostName 192.168.12.182
                 User daniel     
            '';
            };
          };
        };
      };
    };
}
