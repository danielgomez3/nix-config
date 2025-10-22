{
  pkgs,
  config,
  lib,
  ...
}: {
  myHomeManager = {
    helix.enable = true;
    pandoc.enable = true;
    #zed.enable = true;
    pay-respects.enable = true;
    #vnc-viewing.enable = true;
    emacs.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    fzf.enable = true;
  };

  # home.file.".ghc/ghci.conf".text = ''
  #   :set prompt "\ESC[34m\STX%s > \ESC[m\STX"
  #   :set stop :list
  # '';
  home.packages = with pkgs; [
    # Utils
    #reptyr  # FIXME darwin allow unfree
    bat
    jq
    # dev
    #shellcheck csvkit sshx fzf
    # Documentation
    texliveFull
    typst
    typst-live
    typstPackages.fontawesome_0_5_0
    # Fun
    exercism
    toilet
    fortune
    lolcat
    krabby
    cowsay
    figlet
    slides
    #hollywood
    # coding
    nixpkgs-fmt
    devenv
    # Hacking
    openvpn
    nmap
    gobuster
    nikto
    thc-hydra
    dirb
    steghide
    chisel
    python3
    cargo
    # Haskell Dev
    # ghciwatch  # A simple and effective IDE
    # cabal-install stack ghc
  ];
}
