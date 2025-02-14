{inputs,self,...}:{
  imports = [
    inputs.nix-doom-emacs-unstraightened.hmModule
  ];
  programs.doom-emacs = {
    enable = true;
    doomDir = "${self.outPath}/extra/doom.d"; # Directory containing your config.el, init.el
                               # and packages.el files
  };

}
