
{ config, pkgs, lib, inputs, username, ... }:
# let 
#   cutefetch = import ./derivations/cutefetch.nix { inherit pkgs; };  # FIX attempting w/home-manager

# in
{
  
  home-manager = { 
    useGlobalPkgs = true;
    home.packages = with pkgs; [
    # coding/dev
    shellcheck exercism texliveFull csvkit sshx
    pandoc pandoc-include poppler_utils
    # cli apps
    pciutils usbutils
    yt-dlp spotdl vlc yt-dlp android-tools adb-sync unzip android-tools 
    # Fun
    toilet fortune lolcat krabby cowsay figlet
    # Haskell
    cabal-install stack ghc
    # My personal scripts:
    # (import ./my-awesome-script.nix { inherit pkgs;})

    ];
    programs = {

      bash = {
        shellAliases = {
           plan = "cd ~/Productivity/ && hx ~/Productivity/planning/todo.md ~/Productivity/planning/credentials.md";
           zrf = "zellij run floating";
           conf = "cd ~/flake/configurations && hx workspace.nix common.nix";
           notes = "cd ~/Productivity/notes && hx .";
         };
      };

      direnv = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };

      fzf = { 
        enable = false;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
      zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
      
    };
  };
}
