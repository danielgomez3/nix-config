
{ config, pkgs, lib, inputs,  ... }:
let 
#   cutefetch = import ./derivations/cutefetch.nix { inherit pkgs; };  # FIX attempting w/home-manager
  # myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
  #   matplotlib
  # ]);
  cfg = config.services.coding;
  username = config.myConfig.username;
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
        shellcheck exercism csvkit sshx fzf
        pandoc-include poppler_utils graphviz librsvg 
        git-filter-repo 
        # texliveTeTeX
        texliveFull
        # Fun
        toilet fortune lolcat krabby cowsay figlet hollywood
        # coding
        cabal-install stack ghc
        sqlint
        nixpkgs-fmt
        # Hacking
        openvpn nmap gobuster nikto thc-hydra dirb steghide wpscan chisel
        # My personal scripts:
        # (import ./my-awesome-script.nix { inherit pkgs;})

        ];

        # home.file.zellij = {
        #   target = ".config/zellij/config.kdl";
        #   text = ''
        #     default_mode "locked"
        #     scrollback_editor "hx"
        #     pane_frames false
        #     keybinds {
        #         locked {
        #             bind "Alt l" { GoToNextTab; }
        #             bind "Alt h" { GoToPreviousTab; }
        #         }
        #     }
        #   '';
        # };

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

          zellij = {
            enable = true;
            settings = {
              default_mode = "locked";
              scrollback_editor = "hx";
              pane_frames = false;
              keybinds = {
                locked = {
                  "Alt l" = [ "GoToNextTab" ];
                  "Alt h" = [ "GoToPreviousTab" ];
                };
              };
            };
          };
    
          helix = {
            enable = true;
            defaultEditor = true;
            extraPackages = with pkgs; [
              vscode-langservers-extracted
              gopls gotools
              #typescript typescript-language-server
              marksman ltex-ls  # Writing
              nil nixfmt-classic
              clang-tools  # C
              lua-language-server
              rust-analyzer
              # bash-language-server
              haskell-language-server
              omnisharp-roslyn netcoredbg  # C-sharp
              python312Packages.python-lsp-server 
            ];
            settings = {
                # theme = "catppuccin_macchiato";
                editor = {
                  # shell = ["/usr/bin/env" "zsh"];
                  shell = [
                    "zsh"
                    "-c"
                  ];
                  # shell = [
                  #   "/usr/bin/env"
                  #   "zsh"
                  #   "-c"
                  # ];
                  # shell = ["zsh" "-c"];
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
              language-server.pyright = {
                command = "${pkgs.pyright}/bin/pyright-langserver";
                args = [
                  "--stdio"
                ];
              };
              language = [
                {
                  name = "nix";
                  auto-format = true;
                  formatter.command = "${pkgs.nixfmt-classic}/bin/nixfmt-classic";
                }
                {
                  name = "markdown";
                  language-servers = ["marksman" "ltex-ls"];
                }
                {
                  name = "python";
                  auto-format = true;
                  formatter = {
                    command = "${pkgs.ruff}/bin/ruff";
                    args = [
                      "format"
                      "--silent"
                      "-"
                    ];
                  };
                  language-servers = [
                    {
                      name = "pyright";
                    }
                  ];
                }
              ];
            };
          };

          fzf = { 
            enable = true;
            enableBashIntegration = false;
            enableZshIntegration = true;
          };
          pandoc = {
            enable = true;
            templates = {
              "default.latex" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
              "default.markdown" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
              "default.pdf" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
            };
          };
        };
      };
    };
  };
}
