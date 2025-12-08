{
  pkgs,
  config,
  ...
}: {
  programs.bash = {
    enable = false;
    enableCompletion = true;
    bashrcExtra = ''
      export HISTCONTROL=ignoreboth:erasedups
      shopt -s autocd cdspell globstar extglob nocaseglob

      #c() { z "$@" && eza --icons --color=always --group-directories-first; }
      #e() { if [ $# -eq 0 ]; then hx .; else hx "$@"; fi; }
    '';
    shellAliases = {
      f = "fg";
      j = "jobs";
      l = "ls -l";
      ls = "${pkgs.eza}/bin/eza --icons --color=always --group-directories-first";
      la = "${pkgs.eza}/bin/eza -a --icons --color=always --group-directories-first";
      lt = "${pkgs.eza}/bin/eza --icons --color=always --tree --level 2 --group-directories-first";
      lta = "${pkgs.eza}/bin/eza -a --icons --color=always --tree --level 2 --group-directories-first";
      # grep = "grep --color=always -IrnE --exclude-dir='.*'";

      grep = "grep --color=always -IrnE --exclude-dir='.*'";
      less = "less -FR";
      productivity = "cd ~/Documents/productivity/ && hx todo.md credentials.md";
      conf = "cd ~/Projects/repos-personal/flakes/flake/ && hx modules/coding.nix modules/all.nix";
      notes = "cd ~/Documents/productivity/notes && hx .";
      zrf = "zellij run floating";
    };
  };
}
