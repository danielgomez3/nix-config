# configuration.nix
# NOTE: Ubiquitous configuration.nix and home-manager content for all systems:

# Edit this configuration file tco define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, username, ... }:
let 
  nvChad = import ./derivations/nvchad.nix { inherit pkgs; };
  cutefetch = import ./derivations/cutefetch.nix { inherit pkgs; };  # FIX attempting w/home-manager
in
{

  # NOTE: Unique configuration.nix content:
#   services.nextcloud = {                
#   enable = true;                   
#   package = pkgs.nextcloud28;
#   hostName = "localhost";
#   config.adminpassFile = "/home/${username}/flake/nextcloud-admin-pass";
#   # Instead of using pkgs.nextcloud28Packages.apps,
#   # we'll reference the package version specified above
#   extraAppsEnable = true;
# };
  # services.rsyncd = {
  #   enable = true;
  # };

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
    git wget curl pigz tree bat colordiff
    lm_sensors 
    bluez bluez-alsa bluez-tools
    # syncthing 
    google-chrome audacity ardour
    helix zed-editor zellij neomutt
    woeusb ntfs3g
  #   (vscode-with-extensions.override {
  #   vscode = vscodium;
  #   vscodeExtensions = with vscode-extensions; [
  #     bbenoist.nix
  #     ms-python.python
  #     ms-azuretools.vscode-docker
  #     ms-vscode-remote.remote-ssh
  #   ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  #     {
  #       name = "remote-ssh-edit";
  #       publisher = "ms-vscode-remote";
  #       version = "0.47.2";
  #       sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
  #     }
  #   ];
  # })
  ];
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
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
  services = {
    gnome.gnome-online-accounts.enable = true;
    syncthing = {
      enable = true;
      user = username;
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      dataDir = "/home/${username}/.config/syncthing";
    # #   settings = {
    # #     options.urAccepted = -1;
    #   # };
    };
  };


  # NOTE: Ubiquitous home-manager config for every system:
 home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      home.stateVersion = "23.11";
      home.sessionVariables = {
        TERMINAL = "kitty";
      };
      home.packages = with pkgs; [
        # cli apps
        krabby cowsay screen eza cutefetch
        fd xclip wl-clipboard
        youtube-dl spotdl feh vlc yt-dlp android-tools adb-sync unzip
        haskellPackages.patat graph-easy python311Packages.grip
        android-tools 
        # coding
        shellcheck inotify-tools exercism  pandoc poppler_utils
        # gui apps
        firefox texliveFull zoom-us libreoffice slack spotify
        cmus gotop flameshot xournalpp shutter
        gnome.gnome-session
        libsForQt5.kpeople # HACK: Get kde sms working properly
        libsForQt5.kpeoplevcard # HACK: Get kde sms working properly
        # My personal scripts:
        # (import ./my-awesome-script.nix { inherit pkgs;})

      ];
      home.file.".config/nvim" = {
        source = "${nvChad}/nvchad";
        recursive = true;  # copy files recursively
      };

      services = {
        kdeconnect.enable = true;
      };

      programs = with pkgs; {
        ssh = {
          enable = true;
          extraConfig = ''
            Host vps
               HostName 46.226.105.34
               User root
               IdentityFile ~/.ssh/id_ed25519

          '';
        };
        # bash = {
        #   enable = true;
        #   enableCompletion = true;
        #   shellAliases = {
        #     prod = "cd ~/Productivity/planning && hx ~/Productivity/planning/todo.md ~/Productivity/planning/credentials.md";
        #     zrf = "zellij run floating";
        #     conf = "cd ~/flake/ && hx configuration.nix laptop.nix desktop.nix";
        #     notes = "cd ~/Productivity/notes && hx .";
        #     l = "eza --icons --color=always";
        #     lt = "eza --icons --color=always --tree --level 2";
        #   };
        #   bashrcExtra = ''
        #   krabby random 1,2
        #   shopt -s autocd cdspell globstar extglob nocaseglob

        #   '';
        # };


        
        zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          shellAliases = {
            prod = "cd ~/Productivity/planning && hx ~/Productivity/planning/todo.md ~/Productivity/planning/credentials.md";
            zrf = "zellij run floating";
            conf = "cd ~/flake/ && hx configuration.nix laptop.nix desktop.nix";
            notes = "cd ~/Productivity/notes && hx .";
            l = "eza --icons --color=always";
            lt = "eza --icons --color=always --tree --level 2";
          };
          initExtra = ''
            krabby random 1,2
            # when --calendar_today_style=bold,fgred --future=3 ci
            erick=4436788948
            anthony=4434162576
            me=4435377181
            mom=4434723947

            export GIT_ASKPASS=""
            eval "$(direnv hook zsh)"
            export CDPATH=$CDPATH:$HOME
          '';
        };
        starship = {
          enable = true;
          enableZshIntegration = true;
          enableBashIntegration = true;
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
          enableZshIntegration = true;
          enableBashIntegration = true;
        };
        kitty = {
          enable = true;
          theme = "One Dark";
          font = {
            package = pkgs.fira-code-nerdfont;
            # size = 10;
            name = "FiraCode Nerd Font";
          };
          settings = { 
            enable_audio_bell = false;
            confirm_os_window_close = -1;
          };
        extraConfig = ''
          hide_window_decorations yes
          map ctrl+shift+enter new_window_with_cwd
          map ctrl+shift+t new_tab_with_cwd
        '';
        };
        # kitty = {
        #   enable = true;
        #   # theme = "nord_light";
        #   # theme = "Dracula";
        #   font = {
        #     # package = pkgs.victor-mono;
        #     package = pkgs.victor-mono;
        #     # size = 10;
        #     name = "Victor Mono";
        #   };
        #   settings = { 
        #     enable_audio_bell = false;
        #     confirm_os_window_close = -1;
        #   };
        #   extraConfig = ''
        #   font_family VictorMono
        #   italic_font   Victor Mono Italic
        #   bold_font  Victor Mono Bold
        #   map ctrl+shift+enter new_window_with_cwd
        #   hide_window_decorations yes



        #   # A port of forest night by sainnhe
        #   # https://github.com/sainnhe/forest-night

        #   background  #323d43
        #   foreground  #d8caac

        #   cursor                #d8caac

        #   selection_foreground  #d8caac
        #   selection_background  #505a60

        #   color0  #3c474d
        #   color8  #868d80

        #   # red
        #   color1                #e68183
        #   # light red
        #   color9                #e68183

        #   # green
        #   color2                #a7c080
        #   # light green
        #   color10               #a7c080

        #   # yellow
        #   color3                #d9bb80
        #   # light yellow
        #   color11               #d9bb80

        #   # blue
        #   color4                #83b6af
        #   # light blue
        #   color12               #83b6af

        #   # magenta
        #   color5                #d39bb6
        #   # light magenta
        #   color13               #d39bb6

        #   # cyan
        #   color6                #87c095
        #   # light cyan
        #   color14               #87c095

        #   # light gray
        #   color7                #868d80
        #   # dark gray
        #   color15               #868d80


        #   '';
        # };
      
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
          enableBashIntegration = true;
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
          enableBashIntegration = true;
          enableZshIntegration = true;
        };
        neovim = {
          enable = true;
          extraConfig = ''
            set cursorline path+=** ignorecase smartcase
          '';
          # plugins = with pkgs.vimPlugins; [
          #   nvchad
          #   nvchad-ui
          # ];
        };
        vim = {
          enable = true;
          # plugins = with pkgs.vimPlugins; [ vim-airline ];
          settings = { ignorecase = true; };
          extraConfig = ''
            set cursorline path+=** ignorecase smartcase
            set nocompatible wildmenu
          '';
        };
        helix = {
          enable = true;
          defaultEditor = true;
          extraPackages = with pkgs; with nodePackages; [
            vscode-langservers-extracted
            gopls gotools
            typescript typescript-language-server
            marksman ltex-ls  # Writing
            nil nixpkgs-fmt
            clang-tools  # C
            lua-language-server
            rust-analyzer
            bash-language-server
            haskell-language-server
            omnisharp-roslyn netcoredbg  # C-sharp
          ];
          settings = {
              # theme = "everforest_dark";
              # theme = "snazzy";  # Kind of better than dracula! More color!
              # theme = "rose_pine_moon";  # serious mode..
              theme = "zed_onedark";
              editor = {
                mouse = true;
                bufferline = "multiple";
                soft-wrap = {
                  enable = true;
                };
                # line-number = "relative";
                gutters = [
                "diagnostics"
                 "spacer"
                 "diff"
                ];
                cursor-shape = {
                  insert = "bar";
                  normal = "block";
                  select = "underline";
                };
              };
          
          };
          languages = { 
            language-server = {
              typescript-language-server = with pkgs.nodePackages; {
                  command = "${typescript-language-server}/bin/typescript-language-server";
                  args = [ "--stdio" "--tsserver-path=${typescript}/lib/node_modules/typescript/lib" ];  
              };  
            };
          language = [{    name = "markdown";    language-servers = ["marksman" "ltex-ls"];  }];
          };
       
        };
     };
    };
 };
  
}
