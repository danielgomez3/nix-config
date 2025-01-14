{ config, pkgs, lib, inputs, ... }:
let
  username = config.myVars.username;
in
{

  programs = {
    kdeconnect.enable = true;
  };


  environment.systemPackages = with pkgs; [
    xorg.xauth  # for X11 forwarding.
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
        # Sway/Wayland/Hyprland
        grim slurp wl-clipboard xclip xorg.xrandr swayidle swaylock sway-audio-idle-inhibit flashfocus autotiling sway-contrib.grimshot wlprop pw-volume 
        # adwaita-icon-theme adwaita-qt 
        brightnessctl swappy dmenu
        # hyprland
        waybar eww wofi
        # gui apps
        firefox zoom-us slack spotify okular plexamp
        libreoffice hunspell hunspellDicts.uk_UA hunspellDicts.th_TH
        cmus xournalpp pavucontrol
        feh ardour audacity vlc 
        # gnome-session
        libsForQt5.kpeople # HACK: Get kde sms working properly
        libsForQt5.kpeoplevcard # HACK: Get kde sms working properly
        # Misc.
        bluez bluez-alsa bluez-tools
        imagemagick
        caffeine  # Keep awake on command
    ];


    # services.mako = {
    #   enable = true;
    #   defaultTimeout = 16;
    #   maxVisible = 16;
    # };

    services.swayidle = {
      enable = true;
    };

    services = {
      hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "swaylock";
          };
          listener = [
            {
              timeout = 300;
              on-timeout = "swaylock";
            }
            {
              timeout = 390;
              on-timeout = "systemctl suspend";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };


    wayland.windowManager.hyprland = {
      enable = false;
      xwayland.enable = false;
      settings = {
        "$mod" = "SUPER";
        bind = [
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"
          # Move window position
          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, l, movewindow, r"
          "$mod SHIFT, k, movewindow, u"
          "$mod SHIFT, j, movewindow, d"

          "$mod,Return,exec,kitty"
          # "$mod SHIFT,Return,exec,kitty"
          "$mod SHIFT,Q,killactive"   # Close the current window with SUPER+Q
          "$mod SHIFT,E,exit"   # Close the current window with SUPER+Q
          "$mod, F, fullscreen"
          "$mod,R,exec,wofi --show drun"
          # Switch workspaces with mainMod [0-9]
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"
          "$mod, bracketright, workspace, e+1"
          "$mod, bracketleft, workspace, e-1"
          # Move active window to a workspace with mainMod SHIFT [0-9]
          "$mod SHIFT, 1, movetoworkspacesilent, 1"
          "$mod SHIFT, 2, movetoworkspacesilent, 2"
          "$mod SHIFT, 3, movetoworkspacesilent, 3"
          "$mod SHIFT, 4, movetoworkspacesilent, 4"
          "$mod SHIFT, 5, movetoworkspacesilent, 5"
          "$mod SHIFT, 6, movetoworkspacesilent, 6"
          "$mod SHIFT, 7, movetoworkspacesilent, 7"
          "$mod SHIFT, 8, movetoworkspacesilent, 8"
          "$mod SHIFT, 9, movetoworkspacesilent, 9"
          "$mod SHIFT, 0, movetoworkspacesilent, 10"
          "$mod SHIFT, bracketleft, movetoworkspace, -1"
          "$mod SHIFT, bracketright, movetoworkspace, +1"
          # Move/Resize windows with mainMod LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          # "$mod, mouse:273, resizewindow"
        ];
        exec-once = [
          "slack"
          "kdeconnect-sms"
          "plexamp"
          "firefox"
          "pavucontrol"
        ];
        windowrule = [
          "workspace 1 silent, firefox"
          "workspace 2 silent, Slack"
          "workspace 3 silent, org.kde.kdeconnect.sms"
          "workspace 10 silent, Plexamp"
          "workspace 10 silent, pavucontrol"
        ];

        # listener = [
        #   {
        #     timeout = 15;
        #     on-timeout = "systemctl suspend";
        #   }          
        # ];
        general = {
            layout = "master";
          };
        };
      # extraConfig = ''
      # '';
    };

    programs = {

      # waybar = {
      #   enable = true;
      #   settings = [
      #     {
      #       mainBar = {
      #         layer = "top";
      #         position = "top";
      #         height = 30;
      #         # output = [
      #         #   "eDP-1"
      #         #   "HDMI-A-1"
      #         # ];
      #         modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
      #         modules-center = [ "sway/window" "custom/hello-from-waybar" ];
      #         "sway/workspaces" = {
      #           disable-scroll = true;
      #           all-outputs = true;
      #         };
      #         "custom/hello-from-waybar" = {
      #           format = "hello {}";
      #           max-length = 40;
      #           interval = "once";
      #           exec = pkgs.writeShellScript "hello-from-waybar" ''
      #             echo "from within waybar"
      #           '';
      #         };
      #       };
      #     }
      #   ];
      # };

      swaylock = {
        enable = true;
      };
      wezterm = {
        enable = true;
        # package = inputs.wezterm.packages.${pkgs.system}.default;
        extraConfig = ''
          return {
            front_end = "WebGpu",
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
        settings = {
          enable_audio_bell = false;
        };
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
      hyprlock = {
        enable = false;
        # settings = {
        #   general = {
        #     disable_loading_bar = true;
        #     grace = 10;
        #     hide_cursor = true;
        #     no_fade_in = false;
        #   };

        # };
      };

    };
  };
}

