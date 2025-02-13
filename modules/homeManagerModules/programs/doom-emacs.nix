{inputs,self,...}:{
  imports = [ inputs.nix-doom-emacs.hmModule ];
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = "${self.outPath}/extra/doom.d"; # Directory containing your config.el, init.el
                               # and packages.el files
  };

}
