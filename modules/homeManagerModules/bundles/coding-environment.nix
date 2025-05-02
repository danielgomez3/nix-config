{pkgs,config,lib,...}:{
  myHomeManager = {
    helix.enable = true;
    pandoc.enable = true;
    #zed.enable = true;
    #pay-respects.enable = true;
    #vnc-viewing.enable = true;
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
    # dev
    #shellcheck exercism csvkit sshx fzf 
    #pandoc-include poppler_utils graphviz librsvg 
    #git-filter-repo 
    #texliveTeTeX
    texliveFull
    # Fun
    toilet fortune lolcat krabby cowsay figlet 
    #hollywood
    # coding
    nixpkgs-fmt
    # Hacking
    openvpn nmap gobuster nikto thc-hydra dirb steghide chisel
    python3 cargo
    # Haskell Dev
    # ghciwatch  # A simple and effective IDE
    # cabal-install stack ghc
  ];

}
