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
  
  programs = {
    light.enable = true;
    kdeconnect.enable = true;
    zsh.enable = false;
    starship = {
        enable = true;
        # enableZshIntegration = true;
        # enableBashIntegration = true;
        settings = {
          add_newline = false;
        };
    };
  };





  services = { 
    # Enable the GNOME Desktop Environment.
    xserver.displayManager.gdm.enable = false;
    xserver.desktopManager.gnome.enable = false;
    # Enable CUPS to print documents.
    printing.enable = true;
    # Enable sound with pipewire.
    pipewire = {
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


    gnome.gnome-online-accounts.enable = true;
    gnome.gnome-keyring.enable = true;

  };



  hardware.graphics.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  security.rtkit.enable = true;
  security.pam.services.swaylock = {};


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bluez bluez-alsa bluez-tools
    audacity ardour
    helix zed-editor
  ];





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
        krabby cowsay eza entr tldr bc wezterm tree
        dmidecode 
        pciutils usbutils
        fd xclip wl-clipboard pandoc pandoc-include poppler_utils
        yt-dlp spotdl feh vlc yt-dlp android-tools adb-sync unzip
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
          terminal = "wezterm";
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
             plan = "cd ~/Productivity/planning && hx ~/Productivity/planning/todo.md ~/Productivity/planning/credentials.md";
             zrf = "zellij run floating";
             conf = "cd ~/flake/flakes && hx configuration.nix laptop.nix desktop.nix";
             notes = "cd ~/Productivity/notes && hx .";
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

