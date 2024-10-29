# configuration.nix
# NOTE: Ubiquitous configuration.nix and home-manager content for all systems:

# Edit this configuration file tco define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, host, username, ... }:
let 
  # nvChad = import ./derivations/nvchad.nix { inherit pkgs; };
  # cutefetch = import ./derivations/cutefetch.nix { inherit pkgs; };  # FIX attempting w/home-manager
  cfg = config.services.all;  # My custom service called 'all'
  secretspath = builtins.toString inputs.mysecrets;
in
{

  options.services.all = {
    enable = lib.mkEnableOption "My 'all' service!";
  };

  # A custom 'service' called 'all'. If a system has this enabled, it will inherit the following settings!:
  config = lib.mkIf cfg.enable {

    nixpkgs.config.allowUnfree = true;
    sops = {
      # HACK: sops nix Cannot read ssh key '/etc/ssh/ssh_host_rsa_key':
      gnupg.sshKeyPaths = [];
      # used to be ../secrets/secrets.yaml, now we're doing it remote. Now, we're pointing to wherever the git repo was cloned on the system on nixos-rebuild!
      # defaultSopsFile = ../secrets.yaml;
      defaultSopsFile = "${secretspath}/secrets.yaml";
      defaultSopsFormat = "yaml";
      age = {
        # Automatically import host SSH keys as age keys
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        # Specify where it will be stored. Or this will use an age key that's expected to already be in the filesystem
        keyFile = "/home/${username}/.config/sops/age/keys.txt";
        # keyFile = "/var/lib/sops-nix/keys.txt";
        # Generate a new key if the key specified doesn't exist in the first place:
        generateKey = true;
      };
      # Default is true. When true, it checks whether SOPS-encrypted files are valid and can be decrypted at build-time. This ensures that the encrypted files you are using can actually be decrypted by the system and are not corrupted or otherwise unreadable. Toggled off for automatic ssh key pair creation:
      validateSopsFiles = false;
      secrets = {
        user_password = {
          # Decrypt 'user-password' to /run/secrets-for-users/ so it can be used to create the user and assign their password without having to run 'passwd <user>' imperatively:
          neededForUsers = true;
        };
        # duck_dns_token = {};
        # duck_dns_username = {};
        # duck_dns_domain = {};  # XXX: Not working. I wish.
        # duck_dns = {
        #   token = {};
        #   username = {};
        # };
        "duck_dns/token" = {};
        "duck_dns/username" = {};
        github_token = {
          owner = config.users.users.${username}.name;
          group = config.users.users.${username}.group;
        };
        "private_user_ssh_keys/desktop" = {  # This way, it could be server, desktop, whatever!
          # Automatically generate this private key at this location if it's there or not:
          path = "/home/${username}/.ssh/id_ed25519";
          # mode = "600";
          owner = config.users.users.${username}.name;
        };
        # example_key = { };
        # "myservice/my_subdir/my_secret" = {
        #   owner = config.users.users.${username}.name; # Make the token accessible to this user
        #   group = config.users.users.${username}.group; # Make the token accessible to this group
        # };    
      };
    };

    systemd.services = {
      syncthing.environment.STNODEFAULTFOLDER = "true";  # Don't create default ~/Sync folder
    };

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 3;
    };

    networking = {
      hostName = host;  # Define your hostname.
      # nameservers = [ "8.8.8.8" "8.8.4.4" ];
      dhcpcd.enable = true;
      # domain = "home";
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
      firewall = {
        enable = true;
        # Open the necessary UDP ports for PXE boot
        allowedUDPPorts = [ 
          67 69 4011 
        ];
        # Open the necessary TCP port for Pixiecore
        allowedTCPPorts = [ 
          80
          443
          64172 
        ];
        allowPing = true;     # Optional: Allow ICMP (ping)
        # Set default policies to 'accept' for both incoming and outgoing traffic
      };
      # firewall.allowedUDPPorts = [ 67 69 4011 ];
      # firewall.allowedTCPPorts = [ 64172 ];
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
          # PermitRootLogin = "yes";        # Allow root login with password
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
          };
        };
      };
      ddclient = {
        enable = true;
        # The server (API) to update, which is Duck DNS
        server = "www.duckdns.org"; 
        # The protocol for Duck DNS
        protocol = "duckdns";
        username = config.sops.secrets."duck_dns/username".path;
        interval = "5m";
        # Use your Duck DNS token as the password
        passwordFile = config.sops.secrets."duck_dns/token".path;  # Shoutout to sops baby.
        use = "web, web=https://ifconfig.me";
      };
    };


    users = {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      mutableUsers = false;  # Required for a password 'passwd' to be set via sops during system activation (over anything done imperatively)!
      users.root = {
        hashedPasswordFile = config.sops.secrets.user_password.path;  
      };
      users.${username} = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.user_password.path;  # Shoutout to sops baby.
        # password = "123";
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        openssh.authorizedKeys.keys = [
          (builtins.readFile ../keys/desktop.pub)
          (builtins.readFile ../keys/server_root.pub)
        ];
      };
    };
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment = {
      sessionVariables = {
        # GITHUB_TOKEN = config.sops.secrets.github_token.path;  
        GITHUB_TOKEN = "$(cat ${config.sops.secrets.github_token.path})";
      };
      systemPackages = with pkgs; [
        git wget curl pigz vim
        lm_sensors 
        woeusb ntfs3g 
        iptables nftables file toybox 
      ];
    };



    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    home-manager = { 
      extraSpecialArgs = { inherit inputs; };
      users.${username} = {
        home = {
          stateVersion = "24.05";
          packages = with pkgs; [
            dig dmidecode 
            eza entr tldr bc tree zip
            pciutils usbutils 
            # cli apps
            sops age just nixos-anywhere ssh-to-age
            yt-dlp beets spotdl protonvpn-cli_2
            tesseract ocrmypdf
            android-tools adb-sync unzip android-tools ffmpeg mpv ventoy
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
            envExtra = ''
              if [[ -o interactive ]]; then
                  export GITHUB_TOKEN=$(cat /run/secrets/github_token)
              fi
              export HISTCONTROL=ignoreboth:erasedups
              # 1 tab autocomplete:
              #bind 'set show-all-if-ambiguous on'
              #bind 'set completion-ignore-case on'

              c() { z "$@" && eza --icons --color=always --group-directories-first; }
              e() { if [ $# -eq 0 ]; then hx .; else hx "$@"; fi; }

              # NOTE: screenshot
              _s() {
                mkdir -p ./.screenshots/
                read input
                # Generate filename and path
                local filename="''${input}.png"
                local filepath="./.screenshots/''${filename}"
  
                # Take screenshot using slurp and grim
                grim -g "$(slurp)" "$filepath"
  
                # Print Markdown image link to stdout
                echo "![''${input}]($filepath)"
              }

              # NOTE: view markdown image link

              screenshot_clipboard() {
                grim -g "$(slurp)" - | wl-copy
              }
              # NOTE: basically this is deprecated i guess
              _tar(){
                tar -czhvf ~/Backups/"$(basename "$1")-$(date -I)".tar.gz -C $(dirname "$1") $(basename "$1")
              }
              _backup(){
                mkdir -p ~/Backups/
                output_name="backup-$(date -I).tar.gz"
                tar -czhvf ~/Backups/"$output_name" "$@"
              }
            '';
            shellAliases = {
              f = "fg";
              j = "jobs";
              l = "eza --icons --color=always --group-directories-first";
              la = "eza -a --icons --color=always --group-directories-first";
              lt = "eza --icons --color=always --tree --level 2 --group-directories-first";
              lta = "eza -a --icons --color=always --tree --level 2 --group-directories-first";
              # grep = "grep --color=always -IrnE --exclude-dir='.*'";
              less = "less -FR";
              productivity = "cd ~/Documents/productivity/ && hx todo.md credentials.md";
              conf = "cd ~/Projects/repos-personal/flakes/flake/ && hx modules/coding.nix modules/all.nix";
              notes = "cd ~/Documents/notes && hx .";
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
              productivity = "cd ~/Documents/productivity/ && hx todo.md credentials.md";
              conf = "cd ~/Projects/repos-personal/flakes/flake/ && hx modules/coding.nix modules/all.nix";
              notes = "cd ~/Documents/productivity/notes && hx .";
              zrf = "zellij run floating";
            };
          };

          git = {
            enable = true;
            userName = "danielgomez3";
            userEmail = "danielgomezcoder@gmail.com";
            extraConfig = {
              # credential.helper = "store";
            };
          };

          ssh = {
            enable = true;
            matchBlocks = {
              "server-hosts" = {
                host = "github.com gitlab.com";
                identitiesOnly = true;
                identityFile = [
                  # "${config.sops.secrets."private_keys/${host}".path}"
                  # "/home/${username}/.ssh/id_ed25519"
                  "~/.ssh/id_ed25519"
                ];
              };
              "server" = {
                host = "server";
                hostname = "danielgomezcoder@duckdns.org";
                user = "danielgomez3";
              };
              "desktop" = {
                host = "desktop";
                hostname = "192.168.12.182";
                user = "daniel";
              };
              "deploy" = {
                host = "deploy";
                hostname = "192.168.12.149";
                user = "root";
              };
            };
          };


        };
      };
    };
  };





  
}
