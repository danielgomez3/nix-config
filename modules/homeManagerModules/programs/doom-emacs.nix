{inputs,self,pkgs,...}:{
  imports = [
    inputs.nix-doom-emacs-unstraightened.hmModule
  ];
  home.packages = with pkgs; [
    coreutils
    findutils
    fd
    ripgrep
    rsync
    openssh
    scrot
    ormolu
    emacsPackages.lsp-haskell
    # haskellPackages.ghc-mod
    # haskellPackages.brittany

    # Spell checking
    hunspell 
    # aspell  # To do actuall spell correction with z =

    # For Org mode. For inline LaTeX previews, latex and dvipng is needed.
    texliveFull gnuplot

    # For org-download
    gnome-screenshot
  ];
  programs.doom-emacs = {
    enable = true;
    doomDir = "${self.outPath}/extra/doom.d"; # Directory containing your config.el, init. and packages.el files
    extraPackages = epkgs: [
      epkgs.vterm epkgs.treesit-grammars.with-all-grammars
      epkgs.lsp-haskell
      epkgs.org-modern
      epkgs.org-download
      epkgs.flyspell-lazy epkgs.flyspell-correct epkgs.flyspell-correct-helm
    ];
  };

}
