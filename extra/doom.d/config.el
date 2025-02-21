;; Theme
(setq doom-theme 'doom-miramare)

;; Recursively add agenda files
(setq org-agenda-files '("~/Documents/productivity"))

;; Haskell Dev.
(after! lsp-haskell
  (setq lsp-haskell-formatting-provider "ormolu"))
(setq haskell-process-type 'cabal-new-repl)
