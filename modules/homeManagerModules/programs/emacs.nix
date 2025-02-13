{ config, lib, pkgs,  ... }:{
  programs.emacs = {
    enable = true;
    # package = emacsPackages.doom;
    extraConfig = ''
      (pdf-tools-install) ; Standard activation command
      (recentf-mode 1)
      (setq recentf-max-menu-items 25)
      (setq recentf-max-saved-items 25)
      (global-set-key "\C-x\ \C-r" 'recentf-open-files)
      ;; No sound
      (setq visible-bell t) 
      (setq ring-bell-function 'ignore)
      ;;(set-face-attribute 'default nil :font "DejaVu Sans Mono-12")

      ;; Undo
      ;;(global-undo-tree-mode)

      ;; Vanity
      (menu-bar-mode -1)
      (scroll-bar-mode -1)
      (tool-bar-mode -1)

      ;; Better find file stuff:
      (ido-mode t)
    '';

    extraPackages = epkgs: [
        epkgs.pdf-tools
        #epkgs.undo-tree
        epkgs.markdown-mode
        epkgs.nix-mode
        epkgs.chatgpt-shell
    ];
  };
}
