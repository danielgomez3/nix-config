{
  lib,
  pkgs,
  ...
}: {
  programs.helix.enable = true;
  programs.helix.settings = {
    editor = {
      true-color = true;
      text-width = 80;
      rulers = [80];
      mouse = true;
      # shell = [
      #   "zsh"
      #   "-c"
      # ];
      #   bufferline = "multiple";
      #   whitespace = {
      #     render = {
      #       newline = "none";
      #     };
      #     characters = {
      #       newline = "⏎";
      #     };
      #   };
      #   soft-wrap = {
      #     enable = true;
      #     wrap-indicator = "‧ ";
      #   };
      #   line-number = "absolute";
      #   # gutters = [
      #   # "diagnostics"
      #   #  "spacer"
      #   #  "diff"
      #   # ];
      #   gutters = [];
      #   cursor-shape = {
      #     insert = "bar";
      #     normal = "block";
      #     select = "underline";
      #   };
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
      };
      insert = {
        "A-ret" = ["insert_newline" "delete_word_backward"];
      };
    };
  };

  programs.helix.languages = {
    language = [
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
        language-servers = ["marksman" "ltex"];
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

      yaml-language-server = {
        command = lib.getExe pkgs.yaml-language-server;
      };
    };
  };
}
