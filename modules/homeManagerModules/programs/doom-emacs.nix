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

    # hunspell 
    # aspell  # To do actuall spell correction with z =
  ];
  programs.doom-emacs = {
    enable = true;
    doomDir = "${self.outPath}/extra/doom.d"; # Directory containing your config.el, init. and packages.el files
    extraPackages = epkgs: [
      epkgs.vterm epkgs.treesit-grammars.with-all-grammars
      epkgs.lsp-haskell
    ];
  };

}
