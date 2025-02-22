;; Theme
(setq doom-theme 'doom-miramare)

;; Recursively add agenda files
(setq org-agenda-files '("~/Documents/productivity"))

;; Haskell Dev.
(after! lsp-haskell
  (setq lsp-haskell-formatting-provider "ormolu"))
(setq haskell-process-type 'cabal-new-repl)

;; Org mode stuff
(add-hook 'org-mode-hook #'org-modern-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)
