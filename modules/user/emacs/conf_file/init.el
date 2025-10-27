;; ANSI color in compilation buffer
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; Some key bindings
(global-set-key [f3] 'next-match)
(defun prev-match () (interactive nil) (next-match -1))
(global-set-key [(shift f3)] 'prev-match)
(global-set-key [backtab] 'auto-complete)



(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu-devel" . "https://elpa.gnu.org/devel/"))
(package-initialize)
(require 'use-package)
(when (not package-archive-contents)
  (package-refresh-contents))
;;(package-refresh-contents)

(unless (package-installed-p 'nix-mode)
  (package-install 'nix-mode))

;; Keep folder clean ==
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))
(make-directory (expand-file-name "tmp/auto-saves/" user-emacs-directory) t)
(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
      auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))



;; Change theme to doom-themes and configure fonts ==
(load-file (expand-file-name "conf_file/theme.el" user-emacs-directory))

;; Configure interface ==
(load-file (expand-file-name "conf_file/interface_conf.el" user-emacs-directory))

;; Org Capture ==
;; (load-file (expand-file-name "conf_file/org_capture.el" user-emacs-directory))

;; Org Roam ==
;;(load-file (expand-file-name "conf_file/org_roam.el" user-emacs-directory))

;; Org present ==
;;(load-file (expand-file-name "conf_file/org_present.el" user-emacs-directory))

;; Load origami (fold) ==
;;(load-file (expand-file-name "conf_file/origami.el" user-emacs-directory))

;; Close and open "*Shell Command Output*" ==
(load-file (expand-file-name "conf_file/shell_output.el" user-emacs-directory))

;; Load emacs.el ==
(if (file-exists-p "emacs.el")
    (load-file "emacs.el")
)

;; Overlay pour ligne ==
(load-file (expand-file-name "conf_file/line_overlay.el" user-emacs-directory))

;; LSP server ==
(load-file (expand-file-name "conf_file/lsp_server.el" user-emacs-directory))

;; highlight indent guides ==
(load-file (expand-file-name "conf_file/highlight_indent_guides.el" user-emacs-directory))

(bind-key* "C-M-x" 'hexl-insert-hex-string 'hexl-mode)

(add-hook 'coq-mode-hook #'company-coq-mode)




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(highlight-indent-guides-auto-enabled nil)
 '(highlight-indent-guides-bitmap-function 'highlight-indent-guides--bitmap-line)
 '(highlight-indent-guides-method 'bitmap)
 '(highlight-indent-guides-responsive 'top)
 '(package-selected-packages
   '(company company-coq dap-mode doom-themes flycheck helm-lsp helm-xref
	highlight-indent-guides lsp-ui org-present org-roam
	origami projectile proof-general visual-fill-column
	yasnippet))
 '(window-divider-default-bottom-width 0)
 '(window-divider-default-places t)
 '(window-divider-default-right-width 10)
 '(window-divider-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(window-divider ((t (:foreground "#232635")))))
