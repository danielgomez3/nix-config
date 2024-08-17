
{ config, pkgs, lib, inputs, username, ... }:
let 
#   cutefetch = import ./derivations/cutefetch.nix { inherit pkgs; };  # FIX attempting w/home-manager
  myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
    matplotlib
  ]);
  cfg = config.services.coding;
in
{
  options.services.coding = {
    enable = lib.mkEnableOption "coding service";
  };
  config = lib.mkIf cfg.enable {
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
        zellij
        shellcheck exercism texliveFull csvkit sshx fzf
        pandoc pandoc-include poppler_utils haskellPackages.pandoc-plot 
        git-filter-repo
        # Fun
        toilet fortune lolcat krabby cowsay figlet
        # coding
        cabal-install stack ghc
        sqlint
        nixpkgs-fmt
        myPythonEnv poetry
        # My personal scripts:
        # (import ./my-awesome-script.nix { inherit pkgs;})

        ];

        home.file.zellij = {
          target = ".config/zellij/config.kdl";
          text = ''
            theme "rose-pine-moon"
            default_mode "locked"
            scrollback_editor "hx"
            pane_frames false
            keybinds {
                locked {
                    bind "Alt l" { GoToNextTab; }
                    bind "Alt h" { GoToPreviousTab; }
                }
            }
            themes {
            	rose-pine-moon {
            		bg "#44415a"
            		fg "#e0def4"
            		red "#eb6f92"
            		green "#3e8fb0"
            		blue "#9ccfd8"
            		yellow "#f6c177"
            		magenta "#c4a7e7"
            		orange "#fe640b"
            		cyan "#ea9a97"
            		black "#393552"
            		white "#e0def4"
            	}
            }
          '';
        };

        programs = {

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
              python312Packages.python-lsp-server
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
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
          };
        };
      };
    };
  };
}
