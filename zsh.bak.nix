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
    envExtra = ''
      #if [[ -o interactive ]]; then
      #    export GITHUB_TOKEN=$(cat /run/secrets/github_token)
      #fi
      export HISTCONTROL=ignoreboth:erasedups
      # 1 tab autocomplete:
      #bind 'set show-all-if-ambiguous on'
      #bind 'set completion-ignore-case on'

      c() { z "$@" && eza --icons --color=always --group-directories-first; }
      #e() { if [ $# -eq 0 ]; then hx .; else hx "$@"; fi; }

      # NOTE: screenshot
      _s() {
        mkdir -p ./.screenshots/
        read input
        # Generate filename and path
        local filename="''${input}.png"
        local filepath="./.screenshots/''${filename}"

        # Take screenshot using slurp and grim
        grim -g "$(slurp)" "$filepath"

        # Print Markdown image link to stdout
        echo "![''${input}]($filepath)"
      }

      # NOTE: view markdown image link

      screenshot_clipboard() {
        grim -g "$(slurp)" - | wl-copy
      }
      # NOTE: basically this is deprecated i guess
      _tar(){
        tar -czhvf ~/Backups/"$(basename "$1")-$(date -I)".tar.gz -C $(dirname "$1") $(basename "$1")
      }
      _backup(){
        mkdir -p ~/Backups/
        output_name="backup-$(date -I).tar.gz"
        tar -czhvf ~/Backups/"$output_name" "$@"
      }
    '';
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
    };
  };
}
