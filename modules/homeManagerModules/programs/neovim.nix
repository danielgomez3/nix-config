# neovim.nix
# Configuration based on NotAShelf/nvf
# NOTE: this editor is almost good. I just can't get clipboard to work over ssh via wezterm. Helix works out of the box. OMG.
{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    xclip
    wl-clipboard
  ];
  imports = [inputs.nvf.homeManagerModules.default];
  programs.neovim = {
    enable = false;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        #       extraPackages = [
        #         pkgs.jdt-language-server
        #         pkgs.prettier
        #       ];
        #       viAlias = false;
        #       vimAlias = true;

        #       # Plugins
        #       statusline.lualine.enable = true;
        #       telescope.enable = true;
        #       autocomplete.nvim-cmp.enable = true;
        #       autopairs.nvim-autopairs.enable = true;
        #       git.enable = false;
        #       # replaces some of the ui elements
        #       notify.nvim-notify.enable = true;
        #       minimap.codewindow.enable = true;

        #       # Modules

        #       theme = {
        #         enable = true;
        #         # name = "catppuccin";
        #         # style = "frappe";
        #         name = "rose-pine";
        #         style = "moon";
        #       };

        #       # formatter = {
        #       #   conform-nvim.enable = true;
        #       # };

        #       globals = {
        #         clipboard = "os52";
        #       };

        #       options = {
        #         # tabstop = 0; # deleteme
        #         relativenumber = false;
        #         number = false;
        #         signcolumn = "yes"; # avoid text shifting?
        #         ignorecase = true;
        #         smartcase = true;
        #         termguicolors = true;
        #         colorcolumn = "80";
        #         smartindent = false; # deleteme
        #       };
        #       dashboard = {
        #         dashboard-nvim = {
        #           enable = true;
        #           setupOpts = {
        #             theme = "doom";
        #           };
        #         };
        #       };
        #       filetree = {
        #         # neo-tree.enable = true;
        #         nvimTree = {
        #           enable = true;
        #           openOnSetup = false;
        #         };
        #       };

        #       runner = {
        #         run-nvim.enable = true;
        #       };

        #       clipboard = {
        #         enable = true;
        #         registers = "unnamedplus";
        #         providers.xclip.enable = true;
        #         # providers.wl-copy.enable = true;
        #         # providers.xsel.enable = true;
        #       };

        #       snippets.luasnip = {
        #         enable = true;
        #         providers = ["friendly-snippets"];
        #       };

        #       comments = {
        #         comment-nvim.enable = true;
        #       };

        #       lsp = {
        #         enable = true;
        #         formatOnSave = true;
        #         lspkind.enable = true;
        #         lspSignature.enable = true;
        #       };

        #       utility = {
        #         yanky-nvim = {
        #           enable = true; # clipbard
        #           setupOpts.ring.storage = "sqlite";
        #         };
        #         motion = {
        #           precognition.enable = true; # display motion discovery
        #           hop.enable = false;
        #           flash-nvim.enable = true;
        #         };
        #         surround.enable = true;
        #         ccc.enable = true;
        #       };

        languages = {
          #         enableTreesitter = true;
          #         enableFormat = true;

          #         python.enable = true;
          nix.enable = true;
          markdown.enable = true;
          #         fsharp.enable = true;
          #         clang.enable = true;
          #         sql.enable = true;
          #         ts.enable = true;
          #         go.enable = true;
          #         lua.enable = true;
          #         html.enable = true;
          #         php.enable = true;
          #         haskell.enable = true;
          #         typst.enable = true;
          #         java = {
          #           lsp = {
          #             enable = true;

          #             # 'vim.extraPackages.' There are no additional checks performed to see
          #             # if the command provided is valid.
          #             package = ["jdt-language-server" "-data" "~/.cache/jdtls/workspace"];
          #           };
          #         };
          #       };

          #       binds = {
          #         whichKey.enable = true; # Shows all possible options of what keys can do
          #         cheatsheet.enable = true;
          #         # hardtime-nvim.enable = true;
          #       };

          #       presence = {
          #         neocord.enable = true;
          #       };

          #       visuals = {
          #         nvim-scrollbar.enable = false;
          #         nvim-web-devicons.enable = false;
          #         cellular-automaton = {
          #           enable = true;
          #           mappings.makeItRain = "<leader>fml";
          #         };
          #         # Smooth scrolling
          #         cinnamon-nvim.enable = true;
          #         # notification widget
          #         fidget-nvim.enable = true;
          #         # indent blankline
          #         indent-blankline = {
          #           enable = true;
          #           setupOpts = {
          #             scope.enabled = true;
          #           };
          #         };
          #         # highlight cursor
          #         # nvim-cursorline = {
          #         #   enable = true;
          #         #   # setupOpts = {cursorword.enable = true;};
          #         #   setupOpts = {
          #         #     cursorline = {
          #         #       enable = true;
          #         #       # line_number = false; # Disable absolute line numbers
          #         #     };
          #         #     cursorword = {
          #         #       enable = true;
          #         #     };
          #         #   };
          #         # };
          #       };

          #       ui = {
          #         illuminate.enable = false; # underline occurences of a word

          #         noice.enable = true; # replaces ui for 'messages' 'cmdline' and 'popupmenu'
          #         colorizer.enable = false; # this makes color codes show up
          #         modes-nvim.enable = false;
          #         breadcrumbs = {
          #           enable = false;
          #           lualine.winbar.alwaysRender = false;
          #           navbuddy.enable = false;
          #         };
        };
      };
    };
  };
}
