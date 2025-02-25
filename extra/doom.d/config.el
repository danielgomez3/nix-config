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

;; Org-download (for screenshots?)
(if (string= system-wm-type "wayland")
  (setq org-download-screenshot-method "grim -g \"$(slurp)\" %s")
  (setq org-download-screenshot-method "flameshot gui -p %s")
)
(require 'org-download)
; (map! :leader
;       :desc "Insert a screenshot"
;       "i s" 'org-download-screenshot
;       :desc "Insert image from clipboard"
;       "i p" 'org-download-clipboard
;       "i P" 'org-download-clipboard-basename)
