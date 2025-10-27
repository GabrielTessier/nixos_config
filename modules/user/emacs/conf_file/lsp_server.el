
(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
    projectile hydra flycheck company avy which-key helm-xref dap-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
;(require 'helm)
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(add-hook 'rust-mode-hook 'lsp-deferred)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))


(with-eval-after-load 'lsp-mode
  (defun ak-lsp-ignore-semgrep-rulesRefreshed (workspace notification)
    "Ignore semgrep/rulesRefreshed notification."
    (when (equal (gethash "method" notification) "semgrep/rulesRefreshed")
      (lsp--info "Ignored semgrep/rulesRefreshed notification")
      t)) ;; Return t to indicate the notification is handled

  (advice-add 'lsp--on-notification :before-until #'ak-lsp-ignore-semgrep-rulesRefreshed))


;(use-package yasnippet
;  :config
;  (require 'yasnippet)
;  (yas-global-mode 1))

;(yas-reload-all)
;(add-hook 'prog-mode-hook #'yas-minor-mode)


;(use-package flycheck
;  :ensure t
;  :init (global-flycheck-mode))

;(use-package lsp-mode
;  :init
;  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
;  (setq lsp-keymap-prefix "C-c l")
;  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
;         (XXX-mode . lsp)
;         ;; if you want which-key integration
;         (lsp-mode . lsp-enable-which-key-integration))
;  :commands lsp)


;; optionally
;(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
;(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
;(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
;(use-package dap-mode)
;(use-package dap-cpptools) ;to load the dap adapter for your language

;; optional if you want which-key integration
;(use-package which-key
;    :config
;    (which-key-mode))

;(use-package lsp-mode
;    :hook (c-mode . lsp-deferred)
;    :commands (lsp lsp-deferred))


;(require 'eglot)
;(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
;(add-hook 'c-mode-hook 'eglot-ensure)
;(add-hook 'c++-mode-hook 'eglot-ensure)

