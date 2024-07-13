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

  # kanshi systemd service
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };

  security.polkit.enable = true;
  
  programs.light.enable = true;

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


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.wireless.iwd = {
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


  networking.dhcpcd = {
    enable = true;
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


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;


  # Configure keymap in X11
  # services.xserver = {
  #   enable = true;
  #   xkb.layout = "us";
  #   xkb.variant = "";
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.graphics.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  security.rtkit.enable = true;
  security.pam.services.swaylock = {};
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
    extraGroups = [ "wheel" "video" ];
    # shell = pkgs.fish;
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
  programs.zsh.enable = false;
  programs.fish = {
    enable = false;
    shellAliases = {
      plan = "cd ~/Productivity/planning && hx ~/Productivity/planning/todo.md ~/Productivity/planning/credentials.md";
      zrf = "zellij run floating";
      conf = "cd ~/flake/ && hx configuration.nix laptop.nix desktop.nix";
      notes = "cd ~/Productivity/notes && hx .";
      # c =''z "$@"; eza --icons --color=always;'';
      l = "eza --icons --color=always --group-directories-first";
      la = "eza -a --icons --color=always --group-directories-first";
      lt = "eza --icons --color=always --tree --level 2 --group-directories-first";
      lta = "eza -a --icons --color=always --tree --level 2 --group-directories-first";
      grep = "grep --color=always -IrnE --exclude-dir='.*'";
      less = "less -FR";
    };
    shellInit = ''
    function fish_prompt
        starship init fish | source
    end
    set fish_greeting
    function c
      z $argv; and eza --icons --color=always --group-directories-first
    end

    '';  
  };
  programs.starship = {
      enable = true;
      # enableZshIntegration = true;
      # enableBashIntegration = true;
      settings = {
        add_newline = false;
      };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git wget curl pigz tree bat colordiff
    lm_sensors 
    bluez bluez-alsa bluez-tools
    google-chrome audacity ardour
    helix zed-editor zellij neomutt
    woeusb ntfs3g
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Noto Sans" "Source Han Sans" ];
    };
  };


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
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

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
    gnome.gnome-keyring.enable = true;
    syncthing = {
      enable = false;
      user = username;
      # dataDir = "/home/${username}/Documents/";
      configDir = "/home/${username}/.config/syncthing";   # Folder for Syncthing's settings and keys
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
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
        krabby cowsay eza entr tldr bc wezterm
        dmidecode 
        pciutils usbutils
        fd xclip wl-clipboard pandoc pandoc-include poppler_utils
        youtube-dl spotdl feh vlc yt-dlp android-tools adb-sync unzip
        android-tools 
        # coding
        shellcheck exercism texliveFull 
        # gui apps
        firefox zoom-us libreoffice slack spotify okular
        cmus xournalpp pavucontrol
        gnome.gnome-session
        libsForQt5.kpeople # HACK: Get kde sms working properly
        libsForQt5.kpeoplevcard # HACK: Get kde sms working properly
        # Wayland
        grim slurp wl-clipboard xorg.xrandr swayidle swaylock flashfocus autotiling sway-contrib.grimshot
        # Emacs
        ispell
        # Haskell
        cabal-install stack ghc
        # My personal scripts:
        # (import ./my-awesome-script.nix { inherit pkgs;})

      ];

      wayland.windowManager.sway = {
        enable = true;
        extraConfig = ''
          exec sleep 5; systemctl --user start kanshi.service
          bindsym XF86MonBrightnessDown exec light -U 10
          bindsym XF86MonBrightnessUp exec light -A 10
          bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
          bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
          bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
          #bindsym $mod+n exec 'flashfocus --flash'
          for_window [class="^.*"] border pixel 0
          titlebar_border_thickness 0
          titlebar_padding 0
	  
          input * {
            xkb_options caps:escape
          }

          # Sleep
          exec swayidle -w \
        	timeout 500 'swaylock -f' \
        	timeout 600 'swaymsg "output * power off"' \
        	resume 'swaymsg "output * power on"'


          # Vanity
	        exec_always --no-startup-id flashfocus
          exec_always autotiling
        '';
        config = rec {
          modifier = "Mod4";
          terminal = "kitty";
          startup = [
            { command = "firefox"; }
          ];
          bars = [
            {
              extraConfig = ''
                bar {
                  position top
                  mode hide 
                  status_command while date +'%Y-%m-%d %X'; do sleep 1; done
                  colors {
                    statusline #ffffff
                    background #323232
                    inactive_workspace #32323200 #32323200 #5c5c5c
                  }
                }
              '';
            }
          ];
        };
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
        bash = {
          enable = true;
          enableCompletion = true;
          bashrcExtra = ''
          shopt -s autocd cdspell globstar extglob nocaseglob

          c () { z "$@" && eza --icons --color=always --group-directories-first; }
          '';
          shellAliases = {
             plan = "cd ~/Documents/productivity/planning && hx ~/Documents/productivity/planning/todo.md ~/Documents/productivity/planning/credentials.md";
             zrf = "zellij run floating";
             conf = "cd ~/flake/ && hx configuration.nix laptop.nix desktop.nix";
             notes = "cd ~/Documents/productivity/notes && hx .";
             l = "eza --icons --color=always --group-directories-first";
             la = "eza -a --icons --color=always --group-directories-first";
             lt = "eza --icons --color=always --tree --level 2 --group-directories-first";
             lta = "eza -a --icons --color=always --tree --level 2 --group-directories-first";
             grep = "grep --color=always -IrnE --exclude-dir='.*'";
             less = "less -FR";
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
        # kitty = {
        #   enable = true;
        #   theme = "One Dark";
        #   font = {
        #     package = pkgs.jetbrains-mono;
        #     # size = 10;
        #     name = "JetBrains Mono";
        #   };
        #   settings = { 
        #     enable_audio_bell = false;
        #     confirm_os_window_close = -1;
        #   };
        # extraConfig = ''
        #   hide_window_decorations yes
        #   #map ctrl+shift+enter new_window_with_cwd
        #   #map ctrl+shift+t new_tab_with_cwd
        #   font_family JetBrains Mono
        #   bold_font     JetBrains Mono Bold
        #   italic_font   JetBrains Mono Italic
        #   bold_italic_font JetBrains Mono Bold Italic



        # '';
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
          enable = false;
          enableBashIntegration = true;
          enableZshIntegration = true;
        };
        zoxide = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          enableFishIntegration = true;
        };
        emacs = {
          enable = true;
          # package = emacsPackages.doom;
	        extraConfig = ''
				  (pdf-tools-install) ; Standard activation command
				  (recentf-mode 1)
				  (setq recentf-max-menu-items 25)
				  (setq recentf-max-saved-items 25)
				  (global-set-key "\C-x\ \C-r" 'recentf-open-files)
				  ;; No sound
				  (setq visible-bell t) 
				  (setq ring-bell-function 'ignore)
				  ;;(set-face-attribute 'default nil :font "DejaVu Sans Mono-12")
			
			    ;; Undo
				  ;;(global-undo-tree-mode)
			
				  ;; Vanity
				  (load-theme 'dracula t)
				  (menu-bar-mode -1)
				  (scroll-bar-mode -1)
				  (tool-bar-mode -1)
			

          '';
	  
          extraPackages = epkgs: [
      	      epkgs.dracula-theme
	            epkgs.pdf-tools
	            #epkgs.undo-tree
	            epkgs.markdown-mode
	            epkgs.nix-mode
              epkgs.chatgpt-shell
 	        ];
        };
        # TODO: Make a <leader>/ function that will search fuzzily. Every space will interpret '.*'
        vim = {
          enable = true;
          settings = { ignorecase = true; };
          plugins = with pkgs.vimPlugins; [ 
            vim-which-key 
            nord-vim
            vim-markdown
            #bullets-vim
          ];
          extraConfig = ''
            set path+=**/* nocompatible incsearch smartcase ignorecase termguicolors background=dark 
            set wildmenu wildignorecase
            

            "" editing
            filetype plugin indent on
            set noswapfile confirm scrolloff=20
            set autoindent expandtab tabstop=2 shiftwidth=2
            argadd ~/Productivity/notes ~/Productivity/planning/* ~/flake/configuration.nix  " add this single dir and file to my buffer list


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
            colorscheme nord
            "colorscheme desert
            syntax on
            set termguicolors background=dark 
            set laststatus=0 shortmess+=I noshowmode
            set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:
            "let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'haskell', 'cpp']
            " Customize Markdown heading colors
            hi! link markdownHeadingDelimiter Boolean
            hi! link markdownH1 DiffAdd
            hi! link markdownH2 DiffDelete
            hi! link markdownH3 DiffChange
            hi! link markdownH4 debugPC
            hi! link markdownH6 Statement
            hi! link markdownH5 Debug



            " Highlight TODO in markdown doc comments:
            "augroup markdown_todo
            "  autocmd!
            "  autocmd FileType markdown syntax match markdownTodo /\<TODO:.*\>/
            "  autocmd FileType markdown highlight markdownTodo guifg=#FF4500 ctermfg=208
            "augroup END
            "syntax sync minlines=9999  " Put this at the end.
            "syntax sync maxlines=9999
            "syntax sync fromstart
            "set synmaxcol=0
            ""set synmincol=0
            "set redrawtime=10000
            "set maxmempattern=2000000


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
              # theme = "sonokai";
              editor = {
                mouse = true;
                bufferline = "multiple";
                soft-wrap = {
                  enable = true;
                };
                # line-number = "relative";
                # gutters = [
                # "diagnostics"
                #  "spacer"
                #  "diff"
                # ];
                gutters = [
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
