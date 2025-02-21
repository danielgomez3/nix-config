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
    emacsPackages.lsp-haskell

    # hunspell 
    # aspell  # To do actuall spell correction with z =
  ];
  programs.doom-emacs = {
    enable = true;
    doomDir = "${self.outPath}/extra/doom.d"; # Directory containing your config.el, init. and packages.el files
    extraPackages = pkgs: [
      # pkgs.emacsPackages.lsp-haskell
    ];
  };

}
