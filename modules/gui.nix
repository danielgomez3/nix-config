{ config, pkgs, lib, username, ... }:
let
  modKey = "Mod4";
  cfg = config.services.gui;
in
 
{
  options.services.gui = {
    enable = lib.mkEnableOption "gui service";
  };

  config = lib.mkIf cfg.enable {
    hardware.opengl.enable = true;  # NOTE: This might need to be added for laptop too.
  # kanshi systemd service <https://nixos.wiki/wiki/Sway>
    systemd.user.services.kanshi = {
      description = "kanshi daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
      };
    };

    # Brighness and volume <https://nixos.wiki/wiki/Sway>
    users.users.${username}.extraGroups = [ "video" ];
    programs = {
      light.enable = true;
    };

    security.rtkit.enable = true;  # Necessary for Pipewire

    # For Wayland/Sway screen-sharing:
    xdg.portal = {
      config.common.default = "*";
      enable = true;
      wlr = {
        enable = true;
        settings = {
          screencast = {
            max_fps = 15;
            chooser_type = "dmenu";
            chooser_cmd = "${pkgs.wofi}/bin/wofi --show dmenu";
          };
        };
      };
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    services = { 
      # greetd = {
      #   enable = true;
      #   settings = {
      #     default_session = {
      #       command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
      #     };
      #   };
      # };
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

    # hardware.graphics.enable = true;  # NOTE: Enable this if you have problems with sway
    hardware.pulseaudio.enable = false;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    security.pam.services.swaylock = {};
    security.pam.loginLimits = [
      { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
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

    security.polkit.enable = true;
  
    programs = {
      kdeconnect.enable = true;
    };



    home-manager.users.${username} = {
        home.packages = with pkgs; [
            # Sway/Wayland
            grim slurp wl-clipboard xorg.xrandr swayidle swaylock flashfocus autotiling sway-contrib.grimshot wlprop pw-volume gnome.adwaita-icon-theme adwaita-qt brightnessctl swappy 
            # gui apps
            firefox zoom-us slack spotify okular plexamp
            libreoffice hunspell hunspellDicts.uk_UA hunspellDicts.th_TH
            cmus xournalpp pavucontrol
            feh ardour audacity vlc 
            gnome.gnome-session
            libsForQt5.kpeople # HACK: Get kde sms working properly
            libsForQt5.kpeoplevcard # HACK: Get kde sms working properly
            # Misc.
            bluez bluez-alsa bluez-tools
            imagemagick
        ];


        # services.mako = {
        #   enable = true;
        #   defaultTimeout = 16;
        #   maxVisible = 16;
        # };

        wayland.windowManager.sway = {
          enable = true;
          wrapperFeatures.gtk = true;
          extraConfig = ''
            workspace number 1
            exec sleep 5; systemctl --user start kanshi.service
            bindsym XF86MonBrightnessDown exec light -U 10
            bindsym XF86MonBrightnessUp exec light -A 10
            #bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
            #bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
            #bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'

            #bindsym $mod+n exec 'flashfocus --flash'
            for_window [class="^.*"] border pixel 0
            titlebar_border_thickness 0
            titlebar_padding 0
  
            input * {
              xkb_options caps:escape
            }


            # Vanity
            exec_always --no-startup-id flashfocus
            exec_always autotiling

            # Functionality
            # exec sway-audio-idle-inhibit
            no_focus [all]
            focus_on_window_activation none
            assign [class="[Ss]lack"] workspace 2
            assign [class="[Ss]potify" title="[Ss]potify"] workspace 2
            assign [class="[Pp]lexamp" title="[Pp]lexamp"] workspace 2
            assign [title="KDE Connect SMS"] workspace 2
            assign [title="Volume Control"] workspace 10
            bindsym ${modKey}+Semicolon exec --no-startup-id flash_window
          '';
          config = {
            modifier = "${modKey}";
            terminal = "wezterm";
            startup = [
              { command = "slack"; }
              { command = "pavucontrol"; }
            ];
            # keybindings
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

      programs = {

        wezterm = {
          enable = true;
          extraConfig = ''
            -- local wezterm = require 'wezterm'
            -- local mux = wezterm.mux

            -- wezterm.on('gui-startup', function()
            --   -- Tab 1: Plan
            --   local tab, first_pane, window = mux.spawn_window {}
            --   first_pane:send_text "zellij -l welcome\n"
            -- end)

            return {
            --   -- default_prog = { 'zellij', '-l', 'welcome' },
            hide_tab_bar_if_only_one_tab = true,
            color_scheme = "rose-pine",
            }
          '';
        };

        obs-studio = {
          enable = true;
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

        kitty = {
          enable = true;
        };


        # vscode = {
        #   enable = true;
        #   extensions = with pkgs.vscode-extensions; [
        #     dracula-theme.theme-dracula
        #     vscodevim.vim
        #     yzhang.markdown-all-in-one
        #   ];
        # };
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
        };
    };
  };
}
