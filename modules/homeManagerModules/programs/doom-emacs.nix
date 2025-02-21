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

    # hunspell 
    # aspell  # To do actuall spell correction with z =
  ];
  programs.doom-emacs = {
    enable = true;
    doomDir = "${self.outPath}/extra/doom.d"; # Directory containing your config.el, init. and packages.el files
    extraPackages = epkgs: [ epkgs.vterm epkgs.treesit-grammars.with-all-grammars ];
  };

}
