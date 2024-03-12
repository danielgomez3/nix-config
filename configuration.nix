# configuration.nix
# NOTE: Ubiquitous configuration.nix and home-manager content for all systems:

# Edit this configuration file tco define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, username, ... }:
{

  # NOTE: Unique configuration.nix content:
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };
  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    systemd-boot.configurationLimit = 5;
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb.layout = "us";
  #   xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "desktop";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    # packages = with pkgs; [
    #   firefox
    # ];
    openssh = {
      authorizedKeys.keys = [
        ## This is my Desktop pub key:
        # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICKAtRI1bbUVZtT1uSRpI0sD3F4Lc4pTHqgqqoI8x8rV daniel@desktop"
        ## This is my Laptop pub key:
        # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKOydruQkRyP2lx+REMSqEFOcP0hB/s/SBpyG2NBB6rD daniel@laptop

      ];
      
    };
  };
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git wget curl pigz tree
    helix victor-mono
    lm_sensors android-tools
    bluez bluez-alsa bluez-tools
    seafile-shared
    resilio-sync
    syncthing
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 5000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?


  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  security.sudo.wheelNeedsPassword = false;
  services.syncthing.enable = true;


 home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      # NOTE: Ubiquitous home-manager config for every system:
      home.stateVersion = "23.11";
      home.sessionVariables = {
        TERMINAL = "kitty";
      };
      home.packages = with pkgs; [
        # cli apps
        krabby cowsay when unipicker emote
        fd xclip wl-clipboard
        youtube-dl spotdl feh vlc yt-dlp
        slides graph-easy python311Packages.grip
        # coding
        shellcheck 
        # gui apps
        firefox texliveFull zoom-us libreoffice
        cmus gotop flameshot xournalpp
        gnome.gnome-session
        libsForQt5.kpeople # HACK: Get kde sms working properly
        libsForQt5.kpeoplevcard # HACK: Get kde sms working properly
        # My personal scripts:
        # (import ./my-awesome-script.nix { inherit pkgs;})

      ];

      services = {
        kdeconnect.enable = true;
      };

      programs = with pkgs; {
        # bash = {
        #   enable = true;
        #   enableCompletion = true;
        #   # shellAliases = {
        #   #   notes = "hx ~/Productivity";
        #   #   # huya = "hx file2.txt";
        #   # };
        #   bashrcExtra = ''
        #   krabby random 1-4

        #   export GIT_ASKPASS=""
        #   '';
        # };
        zsh = {
          enable = true;
          enableCompletion = true;
          enableAutosuggestions = true;
          shellAliases = {
            prod = "cd ~/Productivity && sudo -E hx ~/Productivity/planning/todo.md ~/Productivity/notes/index.md /etc/nixos/configuration.nix";
          };
          initExtra = ''
            krabby random 1-4
            when --calendar_today_style=bold,fgred --future=3 ci
            erick=4436788948
            anthony=4434162576
            me=4435377181
            mom=4434723947

            export GIT_ASKPASS=""
          '';
        };
        starship = {
          enable = true;
          # enableBashIntegration = true;
          enableZshIntegration = true;
          settings = {
            add_newline = false;
          };
        };
        git = {
          enable = true;
          userName = "danielgomez3";
          userEmail = "danielgomez3@verizon.net";
          extraConfig = {
            credential.helper = "store";
          };
        };
        direnv = {
          enable = true;
          # enableBashIntegration = true;
          enableZshIntegration = true;
        };
        kitty = {
          enable = true;
          theme = "Dracula";
          font = {
            package = pkgs.victor-mono;
            size = 10;
            name = "VictorMono";
          };
          settings = { 
            enable_audio_bell = false;
            confirm_os_window_close = -1;
          };
          extraConfig = ''
          {
            }
          '';
        };
      
      zathura = {
        enable = true;
        options = {
          selection-clipboard = "clipboard";
          scroll-step = 50;
        };
        # extraConfig = 
        # ''
        #     # Clipboard
        #     set selection-clipboard clipboard
        #     set scroll-step 50
        # '';
      };
        fzf = { 
          enable = true;
          # enableBashIntegration = true;
          enableZshIntegration = true;
          # historyWidgetOptions = [
          # "--preview 'echo {}' --preview-window up:3:hidden:wrap"
          # "--bind 'ctrl-/:toggle-preview'"
          # "--color header:italic"
          # "--header 'Press CTRL-/ to view whole command'"
          # ];
        };
        zoxide = {
          enable = true;
          # enableBashIntegration = true;
          enableZshIntegration = true;
        };
        helix = {
          enable = true;
          defaultEditor = true;
          extraPackages = with pkgs; with nodePackages; [
            vscode-langservers-extracted
            gopls gotools
            typescript typescript-language-server
            marksman ltex-ls
            nil nixpkgs-fmt
            clang-tools
            lua-language-server
            rust-analyzer
            bash-language-server
          ];
          settings = {
              theme = "varua";
              editor = {
                bufferline = "multiple";
                soft-wrap = {
                  enable = true;
                };
                line-number = "relative";
                cursor-shape = {
                  insert = "bar";
                  normal = "block";
                  select = "underline";
                };
              };
          
          };
          languages = { 
            language-server.typescript-language-server = with pkgs.nodePackages; {
                command = "${typescript-language-server}/bin/typescript-language-server";
                args = [ "--stdio" "--tsserver-path=${typescript}/lib/node_modules/typescript/lib" ];  
            };  
          language = [{    name = "markdown";    language-servers = ["marksman" "ltex-ls"];  }];
          };
       
        };
     };
    };
 };
  
}
