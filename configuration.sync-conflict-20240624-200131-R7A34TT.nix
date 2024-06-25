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
    shell = pkgs.fish;
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
    enable = true;
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
        krabby cowsay eza cutefetch entr tldr fish 
        dmidecode 
        fd xclip wl-clipboard pandoc poppler_utils
        youtube-dl spotdl feh vlc yt-dlp android-tools adb-sync unzip
        android-tools 
        # coding
        shellcheck exercism 
        # gui apps
        firefox texliveFull zoom-us libreoffice slack spotify
        cmus gotop xournalpp 
        gnome.gnome-session
        libsForQt5.kpeople # HACK: Get kde sms working properly
        libsForQt5.kpeoplevcard # HACK: Get kde sms working properly
        # My personal scripts:
        # (import ./my-awesome-script.nix { inherit pkgs;})

      ];
      # home.file.".config/nvim" = {
      #   source = "${nvChad}/nvchad";
      #   recursive = true;  # copy files recursively
      # };

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


        fish = {
          enable = true;

        };
        
        # zsh = {
        #   enable = false;
        #   enableCompletion = true;
        #   autosuggestion.enable = true;
        #   shellAliases = {
        #     plan = "cd ~/Productivity/planning && hx ~/Productivity/planning/todo.md ~/Productivity/planning/credentials.md";
        #     zrf = "zellij run floating";
        #     conf = "cd ~/flake/ && hx configuration.nix laptop.nix desktop.nix";
        #     notes = "cd ~/Productivity/notes && hx .";
        #     l = "eza --icons --color=always --group-directories-first";
        #     la = "eza -a --icons --color=always --group-directories-first";
        #     lt = "eza --icons --color=always --tree --level 2 --group-directories-first";
        #     lta = "eza -a --icons --color=always --tree --level 2 --group-directories-first";
        #     grep = "grep --color=always -IrnE --exclude-dir='.*'";
        #     less = "less -FR";
        #   };
        #   initExtra = ''
        #     #cutefetch -k $(shuf -i 1-13 -n 1)
        #     #cutefetch $(printf '-k\n-b' | shuf -n 1) $(shuf -i 1-13 -n 1)

        #     # For ^x^e
        #     autoload edit-command-line
        #     zle -N edit-command-line
        #     bindkey '^X^e' edit-command-line

        #     # Dir shortcuts
        #     d="$HOME/Downloads/"

        #     # Remove history duplicates
        #     setopt HIST_EXPIRE_DUPS_FIRST
        #     setopt HIST_IGNORE_DUPS
        #     setopt HIST_IGNORE_ALL_DUPS
        #     setopt HIST_IGNORE_SPACE
        #     setopt HIST_FIND_NO_DUPS
        #     setopt HIST_SAVE_NO_DUPS

           
        #     export GIT_ASKPASS=""
        #     eval "$(direnv hook zsh)"
        #     c () { z "$@" && eza --icons --color=always --group-directories-first; }

        #   '';
        # };
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
            name = "Fira Code Nerfont";
          };
          settings = { 
            enable_audio_bell = false;
            confirm_os_window_close = -1;
          };
        extraConfig = ''
          hide_window_decorations yes
          #map ctrl+shift+enter new_window_with_cwd
          #map ctrl+shift+t new_tab_with_cwd



#          # Nord Colorscheme for Kitty
#          # Based on:
#          # - https://gist.github.com/marcusramberg/64010234c95a93d953e8c79fdaf94192
#          # - https://github.com/arcticicestudio/nord-hyper
#
#          foreground            #D8DEE9
#          background            #2E3440
#          selection_foreground  #000000
#          selection_background  #FFFACD
#          url_color             #0087BD
#          cursor                #81A1C1
#
#          # black
#          color0   #3B4252
#          color8   #4C566A
#
#          # red
#          color1   #BF616A
#          color9   #BF616A
#
#          # green
#          color2   #A3BE8C
#          color10  #A3BE8C
#
#          # yellow
#          color3   #EBCB8B
#          color11  #EBCB8B
#
#          # blue
#          color4  #81A1C1
#          color12 #81A1C1
#
#          # magenta
#          color5   #B48EAD
#          color13  #B48EAD
#
#          # cyan
#          color6   #88C0D0
#          color14  #8FBCBB
#
#          # white
#          color7   #E5E9F0
#          color15  #ECEFF4
#
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
          enableFishIntegration = true;
        };
        neovim = {
          enable = true;
          extraConfig = ''
	  set path+=**/* nocompatible incsearch smartcase ignorecase termguicolors background=dark wildmenu wildignorecase
	  colorscheme desert
	  set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:
	  set laststatus=0 shortmess+=I noshowmode
	  "let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'haskell', 'cpp']

          let mapleader=" "
          nnoremap <leader>f :edit %:p:h/*<C-D>
          nnoremap <leader>F :edit %:p:h/*<C-D>*/*
	  nnoremap <leader>w :update<CR>
          nnoremap <leader>q :xa<CR>
          nnoremap <leader>x :close<CR>
          nnoremap <leader>o :browse oldfiles<CR>
          nnoremap <leader>n :set rnu! cursorline! list! noshowmode!<CR>
          nnoremap <leader>N :set number! cursorline! list! noshowmode!<CR>
          vnoremap <leader>y "+y
          argadd ~/Productivity/notes ~/Productivity/planning/* ~/flake/configuration.nix            
	  nnoremap <leader>b :buffer<Space><C-D>
          " TODO save and reload vimrc from anywhere
          '';
        };
        # TODO: Make a <leader>/ function that will search fuzzily. Every space will interpret '.*'
        vim = {
          enable = true;
          settings = { ignorecase = true; };
          plugins = with pkgs.vimPlugins; [ 
            vim-which-key 
            #nord-vim
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
            nnoremap <leader>c :cw
            nnoremap <leader>n :cn
            nnoremap <leader>p :cp


            function Term()
              cd %:p:h | execute 'bo ter++rows=10' | tcd
            endfunction
            nnoremap <leader>t :call Term()<CR>


            "" vanity
            "colorscheme nord
            colorscheme desert
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
              # theme = "zed_onedark";
              theme = "varua";
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
