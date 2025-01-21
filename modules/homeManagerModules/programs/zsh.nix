{
  pkgs,
  config,
  ...
}: {

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
    };
    shellAliases = {
      f = "fg";
      j = "jobs";
      l = "eza --icons --color=always --group-directories-first";
      la = "eza -a --icons --color=always --group-directories-first";
      lt = "eza --icons --color=always --tree --level 2 --group-directories-first";
      lta = "eza -a --icons --color=always --tree --level 2 --group-directories-first";
      # grep = "grep --color=always -IrnE --exclude-dir='.*'";
      less = "less -FR";
      productivity = "cd ~/Documents/productivity/ && hx todo.md credentials.md";
      conf = "cd ~/Projects/repos-personal/flakes/flake/ && hx modules/coding.nix modules/all.nix";
      notes = "cd ~/Documents/notes && hx .";
      zrf = "zellij run floating";
      send_downloads_to_server = "${pkgs.rsync}/bin/rsync --remove-source-files -avz ~/Downloads/* server:~/";
      send_downloads_to_desktop = "${pkgs.rsync}/bin/rsync --remove-source-files -avz ~/Downloads/* desktop:~/";
    };
    zplug = {
      enable = true;
      plugins = [
        {name = "hlissner/zsh-autopair";}
      ];
    };
  };
}
