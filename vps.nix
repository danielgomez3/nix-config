{ config, pkgs, lib, inputs, modulesPath, username, host, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.default
      (modulesPath + "/virtualisation/openstack-config.nix")
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # NOTE: Unique configuration.nix content for desktop:
    config = {
    boot.initrd.kernelModules = [
      "xen-blkfront" "xen-tpmfront" "xen-kbdfront" "xen-fbfront"
      "xen-netfront" "xen-pcifront" "xen-scsifront"
    ];

    # Show debug kernel message on boot then reduce loglevel once booted
    boot.consoleLogLevel = 7;
    boot.kernel.sysctl."kernel.printk" = "4 4 1 7";

    # For "openstack console log show"
    boot.kernelParams = [ "console=ttyS0" ];
    systemd.services."serial-getty@ttyS0" = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Restart = "always";
    };

    # The device exposed by Xen
    boot.loader.grub.device = lib.mkForce "/dev/xvda";

    # This is to get a prompt via the "openstack console url show" command
    systemd.services."getty@tty1" = {
      enable = lib.mkForce true;
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Restart = "always";
    };

    # This is required to get an IPv6 address on our infrastructure
    networking.tempAddresses = "disabled";

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    system.stateVersion = "23.11";
  };
  # NOTE: Unique home-manager config for laptop:
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
          # My personal scripts:
          # (import ./my-awesome-script.nix { inherit pkgs;})

        ];

        services = {
          kdeconnect.enable = true;
        };

        programs = with pkgs; {
          ssh = {
            enable = true;
            extraConfig = ''
            Host vps
               HostName 92.243.25.217
               User root
               IdentityFile ~/.ssh/id_ed25519

            '';
          };
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
  # NOTE: Unique hardware-configuration.nix content for laptop:


















  
  # networking.hostName = host; # Define your hostname.
  # services = {
  #   syncthing = {
  #     enable = true;
  #     user = username;
  #     dataDir = "/home/${username}/";
  #     configDir = "/home/${username}/.config/syncthing";
  #     settings = {
  #       devices = {
  #         "desktop" = { id = "AVLUKCW-YQFFBN6-VLK4WIO-3WSRN6D-LJSVRRE-YZYSF6Z-J5RV2JD-MOYEUAN"; autoAcceptFolders = true;};
  #       };
  #     };
  #   };
  # };

}



