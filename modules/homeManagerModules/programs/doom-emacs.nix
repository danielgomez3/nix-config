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
    hunspell
  ];
  programs.doom-emacs = {
    enable = true;
    doomDir = "${self.outPath}/extra/doom.d"; # Directory containing your config.el, init. and packages.el files
    # extraPackages = epkgs: [
    #   pkgs.emacsPackages.org-attach-screenshot
    # ];
  };

}
