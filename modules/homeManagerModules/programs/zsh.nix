{
  pkgsUnstable,
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    package = pkgsUnstable.zsh;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      ignorePatterns = ["rm *" "pkill *" "cp *"];
      ignoreAllDups = true;
    };
    shellAliases = {
      # f = "fg";
      # j = "jobs";
      l = "ls -l";
      ls = "${pkgs.eza}/bin/eza --icons --color=always --group-directories-first";
      la = "${pkgs.eza}/bin/eza -a --icons --color=always --group-directories-first";
      lt = "${pkgs.eza}/bin/eza --icons --color=always --tree --level 2 --group-directories-first";
      lta = "${pkgs.eza}/bin/eza -a --icons --color=always --tree --level 2 --group-directories-first";
      # grep = "grep --color=always -IrnE --exclude-dir='.*'";
      # less = "less -FR";
      conf = "cd ~/Projects/repos-personal/flakes/flake/ && hx modules/coding.nix modules/all.nix";
      notes = "cd ~/Documents/notes/files && hx .";
      zrf = "zellij run floating";
      jambi = "jambi -c $HOME/.config/jambi/config.toml record --live";
      # send_desktop_downloads_to_server = "${pkgs.rsync}/bin/rsync --remove-source-files -avz desktop:~/Downloads/* server:~/Downloads/";
      # send_desktop_downloads_to_server_cwd = "${pkgs.rsync}/bin/rsync --remove-source-files -avz desktop:~/Downloads/* server:~/Downloads/";
    };
    # sessionVariables = {
    # };
    initContent = ''
      d=$HOME/Downloads
      WORDCHARS='*?[]~=&;!$%^(){}<>"'
      run(){ hap run --check "$@" > /dev/null & }

      # edit-command-line, emacs keybinds
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^X^E" edit-command-line

    '';
    zplug = {
      enable = true;
      plugins = [
        {name = "hlissner/zsh-autopair";}
        # {name = "popstas/zsh-command-time";}
        # {name = "chriskempson/base16-shell";}
      ];
    };
  };
}
