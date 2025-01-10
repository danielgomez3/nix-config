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
      image = "${self.outPath}/modules/additional/wallpapers/white.jpg";
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
          (builtins.readFile "${self.outpath}"hosts/desktop/key.pub)
          (builtins.readFile "${self.outpath}"hosts/server/key.pub)
          (builtins.readFile "${self.outpath}"hosts/laptop/key.pub)
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
          (builtins.readFile "${self.outpath}"hosts/desktop/key.pub)
          (builtins.readFile "${self.outpath}"hosts/server/key.pub)
          (builtins.readFile "${self.outpath}"hosts/laptop/key.pub)
          # Needed for Colmena b/c doesn't use root for colmena?
          (builtins.readFile "${self.outpath}"hosts/desktop/root-key.pub)
          (builtins.readFile "${self.outpath}"hosts/laptop/root-key.pub)
          (builtins.readFile "${self.outpath}"hosts/server/root-key.pub)
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
    home-manager = { 
      backupFileExtension = "hm-backup";
      extraSpecialArgs = { inherit inputs; };
      users.${username} = {
        home = {
          stateVersion = "24.05";
          packages = with pkgs; [
            dig dmidecode 
            eza entr tldr bc tree zip
            pciutils usbutils 
            cifs-utils samba
            # cli apps
            yt-dlp beets spotdl protonvpn-cli_2
            tesseract ocrmypdf
            android-tools adb-sync unzip android-tools ffmpeg mpv ventoy
            # Nix
            sops  just nixos-anywhere ssh-to-age colmena disko
          ];
        };
        # stylix.targets.vim.enable = false;

        programs = {

          starship = {
            enable = true;
            enableBashIntegration = false;
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
              #if [[ -o interactive ]]; then
              #    export GITHUB_TOKEN=$(cat /run/secrets/github_token)
              #fi
              export HISTCONTROL=ignoreboth:erasedups
              # 1 tab autocomplete:
              #bind 'set show-all-if-ambiguous on'
              #bind 'set completion-ignore-case on'

              c() { z "$@" && eza --icons --color=always --group-directories-first; }
              #e() { if [ $# -eq 0 ]; then hx .; else hx "$@"; fi; }

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

              #c() { z "$@" && eza --icons --color=always --group-directories-first; }
              #e() { if [ $# -eq 0 ]; then hx .; else hx "$@"; fi; }
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
            userEmail = "danielgomezcoder@gmail.com";  # FIXME: use sops nix, but doesn't seem to work:     defaults.email = "${toString config.sops.secrets.email}";

            extraConfig = {
              credential.helper = "store";
            };
          };

          ssh = {
            enable = true;
            matchBlocks = {
              "server" = {
                # hostname = "server.danielgomezcoder.org";
                hostname = "server";
                user = "danielgomez3";  # FIXME: use sops nix
              };
              "desktop" = {
                hostname = "desktop";
                user = "daniel";  # FIXME: use sops nix
              };
              "laptop" = {
                hostname = "laptop";
                user = "daniel";  # FIXME: use sops nix
              };
              # "laptop" = {
              #   host = "deploy";
              #   hostname = "danielgomezcoder-l.duckdns.org";
              #   user = "root";  # FIXME: use sops nix
              # };
            };
          };

          vim = {
            enable = false;
            # settings = { ignorecase = true; };
            # plugins = with pkgs.vimPlugins; [ 
            #   vim-which-key 
            #   vim-markdown
            #   #bullets-vim
            # ];
            extraConfig = ''
              set path+=**/* nocompatible incsearch smartcase ignorecase termguicolors background=dark mouse-=a
              set wildmenu wildignorecase


              "" editing
              filetype plugin indent on
              set noswapfile confirm scrolloff=20
              set autoindent expandtab tabstop=2 shiftwidth=2
              "" argadd ~/Productivity/notes ~/Productivity/planning/* ~/flake/configuration.nix  " add this single dir and file to my buffer list


              "" Netrw
              let g:netrw_banner = 0
              "autocmd FileType netrw call feedkeys("/\<c-u>", 'n')


              "" Shortcuts
              let mapleader=" "
              nnoremap <leader>f :edit %:p:h/*<C-D>
              nnoremap <leader>F :edit %:p:h/*<C-D>*/*
              nnoremap <leader>g :grep -IrinE "" .<Left><Left><Left>
              nnoremap <leader>G :vimgrep "//" %<Left><Left><Left><Left>
              nnoremap <leader>w :update<CR>
              nnoremap <leader>q :xa<CR>
              nnoremap <leader>x :close<CR>
              nnoremap <leader>o :browse oldfiles<CR>
              " TODO save and reload vimrc from anywhere
              vnoremap <leader>y "+y
              "nnoremap <leader>b :ls<CR>:buffer<space>
              nnoremap <leader>b :buffer<Space><C-D>
              "nnoremap <leader>n :set rnu! cursorline! list! noshowmode!<CR>
              nnoremap <leader>n :cn<CR>
              nnoremap <leader>p :cp<CR>
              nnoremap <leader>c :cope<CR>


              function Term()
                cd %:p:h | execute 'bo ter++rows=10' | tcd
              endfunction
              nnoremap <leader>t :call Term()<CR>


              "" vanity
              syntax on
              "set termguicolors background=dark 
              set laststatus=0 shortmess+=I noshowmode
              set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:
              "let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'haskell', 'cpp']
            '';
          };

          neovim = {
            enable = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
          };

          
        };
      };
  };





  
}
