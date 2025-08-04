# helix.nix
# author: danielgomez3
{
  lib,
  pkgs,
  ...
}: {
  programs.helix.enable = true;
  programs.helix.defaultEditor = true;
  programs.helix.extraPackages = [pkgs.simple-completion-language-server];
  programs.helix.settings = {
    # theme = "nord-night";
    editor = {
      true-color = true;
      text-width = 80;
      rulers = [80];
      auto-pairs = false;
      # snippet-tab = true; # smart tab jumping to snippet placeholders
      mouse = true;
      # shell = [
      #   "zsh"
      #   "-c"
      # ];
      bufferline = "multiple";
      whitespace = {
        render = {
          newline = "none";
        };
        characters = {
          newline = "⏎";
        };
      };
      soft-wrap = {
        enable = true;
        wrap-indicator = "‧ ";
      };
      #   line-number = "absolute";
      #   # gutters = [
      #   # "diagnostics"
      #   #  "spacer"
      #   #  "diff"
      #   # ];
      #   gutters = [];
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      #   # Diagnostics
      #   end-of-line-diagnostics = "hint";
      #   inline-diagnostics = {
      #     cursor-line = "disable";
      #     other-lines = "disable";
      #   };
    };

    keys = {
      normal = {
        space = {
          t = ":toggle soft-wrap.enable";
        };
        # shift-ZZ equivalent
        Z = {
          Q = ":quit!";
          Z = ":write-quit!";
        };
      };
      insert = {
        "A-ret" = ["insert_newline" "delete_word_backward"];
      };
    };
  };

  programs.helix.languages = {
    language = [
      {
        name = "javascript";
        auto-format = true;
        formatter = {
          command = lib.getExe pkgs.nodePackages.prettier;
          args = ["--parser" "babel"];
        };
        language-servers = ["typescript-language-server"];
      }
      {
        name = "typescript";
        auto-format = true;
        formatter = {
          command = lib.getExe pkgs.nodePackages.prettier;
          args = ["--parser" "typescript"];
        };
        language-servers = ["typescript-language-server"];
      }
      {
        name = "bash";
        auto-format = true;
        formatter = {
          command = lib.getExe pkgs.shfmt;
          args = ["-i" "2"];
        };
      }

      {
        name = "css";
        auto-format = true;
        formatter = {
          command = lib.getExe pkgs.nodePackages.prettier;
          args = ["--parser" "css"];
        };
      }

      {
        name = "git-commit";
        language-servers = ["ltex"];
      }

      {
        name = "go";
        auto-format = true;
      }

      {
        name = "html";
        formatter = {
          command = lib.getExe pkgs.nodePackages.prettier;
          args = ["--parser" "html"];
        };
      }

      {
        name = "markdown";
        auto-format = true;
        soft-wrap.enable = true;
        formatter = {
          command = lib.getExe pkgs.nodePackages.prettier;
          args = ["--parser" "markdown"];
        };
        language-servers = ["marksman" "ltex" "scls"];
      }

      {
        name = "nix";
        auto-format = true;
        language-servers = ["nixd"];
      }
      {
        name = "python";
        language-servers = ["basedpyright" "ruff"];
        auto-format = true;
        formatter = {
          command = lib.getExe pkgs.ruff;
          args = ["format" "--line-length=80" "-"];
        };
      }

      {
        name = "sql";
        language-servers = ["sqls"];
      }

      {
        name = "xml";
        language-servers = ["lemminx"];
      }
    ];

    language-server = {
      scls = {
        command = lib.getExe pkgs.simple-completion-language-server;
        config = {
          max_completion_items = 100; # set max completion results len for each group: words, snippets, unicode-input
          feature_words = true; # enable completion by word
          feature_snippets = true; # enable snippets
          snippets_first = true; # completions will return before snippets by default
          snippets_inline_by_word_tail = true; # suggest snippets by WORD tail, for example text `xsq|` become `x^2|` when snippet `sq` has body `^2`
          feature_unicode_input = true; # enable "unicode input"
          feature_paths = true; # enable path completion
          citation = true;
          feature_citations = true; # enable citation completion (only on `citation` feature enabled)
        };
      };

      basedpyright = {
        command = "${pkgs.basedpyright}/bin/basedpyright-langserver";
        args = ["--stdio"];
      };

      bash-language-server = {
        command = lib.getExe pkgs.bash-language-server;
      };

      docker-compose-langserver = {
        command = "${pkgs.docker-compose-language-service}/bin/docker-compose-langserver";
      };

      golangci-lint = {
        command = lib.getExe pkgs.golangci-lint;
      };

      gopls = {
        command = lib.getExe pkgs.gopls;
      };

      lemminx = {
        command = lib.getExe pkgs.lemminx;
      };

      ltex = {
        command = "${pkgs.ltex-ls}/bin/ltex-ls";
      };

      marksman = {
        command = lib.getExe pkgs.marksman;
      };

      nixd = {
        command = lib.getExe pkgs.nixd;
        config.nixd = {
          formatting.command = ["${lib.getExe pkgs.alejandra}"];
        };
      };

      ruff = {
        command = lib.getExe pkgs.ruff;
      };

      superhtml = {
        command = lib.getExe pkgs.superhtml;
      };

      sqls = {
        command = pkgs.sqls;
      };

      taplo = {
        command = lib.getExe pkgs.taplo;
      };

      vscode-css-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server";
      };

      vscode-html-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-html-language-server";
      };

      vscode-json-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-json-language-server";
      };

      typescript-language-server = {
        command = lib.getExe pkgs.nodePackages.typescript-language-server;
        args = ["--stdio"];
      };

      yaml-language-server = {
        command = lib.getExe pkgs.yaml-language-server;
      };
    };
  };
}
