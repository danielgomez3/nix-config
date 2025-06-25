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
      # send_desktop_downloads_to_server = "${pkgs.rsync}/bin/rsync --remove-source-files -avz desktop:~/Downloads/* server:~/Downloads/";
      # send_desktop_downloads_to_server_cwd = "${pkgs.rsync}/bin/rsync --remove-source-files -avz desktop:~/Downloads/* server:~/Downloads/";
    };
    initContent = ''
      d=$HOME/Downloads
    '';
    zplug = {
      enable = true;
      plugins = [
        {name = "hlissner/zsh-autopair";}
        {name = "p1r473/zsh-hist-delete-fzf";}
        # {name = "spaceship-prompt/spaceship-prompt";}
      ];
    };
  };
}
