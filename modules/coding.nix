
{ config, pkgs, lib, inputs, username, ... }:
with lib;
let 
#   cutefetch = import ./derivations/cutefetch.nix { inherit pkgs; };  # FIX attempting w/home-manager
  myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
    matplotlib
  ]);
  cfg = config.services.coding;
in
{
  options.services.coding = {
    enable = mkEnableOption "coding service";
    greeter = mkOption {
      type = types.str;
      default = "world";
    };
  };
  config = mkIf cfg.enable {
    #virtualisation.docker.enable = true;
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      dataDir = "/var/lib/mysql";
      ensureUsers = [
        {
          name = "root";
          ensurePermissions = {
            "*.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    home-manager = { 
      useGlobalPkgs = true;
      users.${username} = {
        home.packages = with pkgs; [
        # dev
        shellcheck exercism texliveFull csvkit sshx fzf
        pandoc pandoc-include poppler_utils haskellPackages.pandoc-plot 
        myPythonEnv
        # cli apps
        pciutils usbutils
        yt-dlp spotdl vlc yt-dlp android-tools adb-sync unzip android-tools 
        # Fun
        toilet fortune lolcat krabby cowsay figlet
        # coding
        cabal-install stack ghc
        sqlint
        nixpkgs-fmt
        # My personal scripts:
        # (import ./my-awesome-script.nix { inherit pkgs;})

        ];
        programs = {

          starship = {
            enable = true;
            enableBashIntegration = true;
          };

          direnv = {
            enable = true;
            enableZshIntegration = true;
            enableBashIntegration = true;
          };

          zoxide = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
            enableFishIntegration = true;
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
                theme = "rose_pine";  # serious mode..
                editor = {
                  true-color = true;
                  mouse = true;
                  bufferline = "multiple";
                  # whitespace.characters = {
                  #   newline = "⏎";
                  # };
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

        fzf = { 
          enable = false;
          enableBashIntegration = true;
          enableZshIntegration = true;
        };

        zellij = {
          enable = true;
          settings = {
            # default_mode = "locked";
            pane_frames = false;
            theme = "default";
            themes = {
              default = {
                bg = "#403d52";
                fg = "#e0def4";
                red = "#eb6f92";
                green = "#31748f";
                blue = "#9ccfd8";
                yellow = "#f6c177";
                magenta = "#c4a7e7";
                orange = "#fe640b";
                cyan = "#ebbcba";
                black = "#26233a";
                white = "#e0def4";
              };
            };
          };
        };

        };
      };
    };
  };
}
