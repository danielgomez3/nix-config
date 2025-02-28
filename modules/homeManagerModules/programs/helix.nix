{pkgs, pkgsUnstable, ...}:{

  programs.helix = {
    enable = true;
    package = pkgsUnstable.helix;
    defaultEditor = true;
    extraPackages = [
      pkgs.vscode-langservers-extracted
      pkgs.gopls pkgs.gotools
      #typescript typescript-language-server
      pkgs.marksman pkgsUnstable.ltex-ls-plus  # Writing
      pkgs.nil pkgs.nixfmt-classic
      pkgs.astyle pkgs.clang-tools  # C
    
      pkgs.lua-language-server
      pkgs.rust-analyzer
      # bash-language-server
      pkgs.haskell-language-server
      pkgs.omnisharp-roslyn pkgs.netcoredbg  # C-sharp
      pkgs.python312Packages.python-lsp-server 
    ];
    settings = {

        editor = {
          # shell = ["/usr/bin/env" "zsh"];
          end-of-line-diagnostics = "hint";
          inline-diagnostics = {
            cursor-line = "error";
            other-lines = "error";
          };
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
            wrap-indicator = "";  # Make the car empty. Looks ugly, and there's already a symbol at the end of the line.
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

      keys = {
        normal = {
          space = {
            t = ":toggle soft-wrap.enable";
          };
        };
    
      };

    };

    languages = {

      language-server = {

        pyright = {
          command = "${pkgs.pyright}/bin/pyright-langserver";
          args = [
            "--stdio"
          ];
        };

        # ltex-ls-plus = {
        #   config = {
        #     ltex = {
        #       diagnosticSeverity = "warning";
        #       disabledRules = {
        #         "en-US" = [ "PROFANITY" ];
        #         "en-GB" = [ "PROFANITY" ];
        #       };
        #       dictionary = {
        #         "en-US" = [ "builtin" ];
        #         "en-GB" = [ "builtin" ];
        #       };
        #     };
        #   };
        # };

      };

      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-classic}/bin/nixfmt-classic";
        }
        {
          name = "markdown";
          language-servers = ["marksman" "ltex-ls-plus"];
          text-width = 80;
          soft-wrap.enable = true;
          soft-wrap.wrap-at-text-width = true;
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
            {
              name = "ltex-ls";
            }
          ];
        }
      ];
    };


  };
}
