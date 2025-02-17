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
  ];
  programs.doom-emacs = {
    enable = true;
    doomDir = "${self.outPath}/extra/doom.d"; # Directory containing your config.el, init.el and packages.el files
    # services.emacs.enable = true;
    # extraPackages = epkgs: [
    #   pkgs.emacsPackages.org-attach-screenshot
    # ];
  };

}
