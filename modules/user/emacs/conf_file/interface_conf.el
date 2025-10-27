
(setq inhibit-startup-screen t)

;; Hide unneeded UI elements (this can even be done in my/org-present-start!)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; Let the desktop background show through
;;(set-frame-parameter (selected-frame) 'alpha '(97 . 100))
;;(add-to-list 'default-frame-alist '(alpha . (90 . 90)))

(global-display-line-numbers-mode)
(column-number-mode)

;; Séparation entre les windows
(custom-set-variables
 '(window-divider-default-bottom-width 0)
 '(window-divider-default-places t)
 '(window-divider-default-right-width 10)
 '(window-divider-mode t))

(custom-set-faces
 '(window-divider ((t (:foreground "#232635")))))
