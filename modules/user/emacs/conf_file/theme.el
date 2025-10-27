;; Install doom-themes
(unless (package-installed-p 'doom-themes)
  (package-install 'doom-themes))

;; Load up doom-palenight for the System Crafters look
(load-theme 'doom-palenight t)


(defun efs/set-font-faces ()
  (message "Setting faces!")
  (set-face-attribute 'default nil :font "JetBrains Mono" :weight 'light :height 140) ; 180
  (set-face-attribute 'fixed-pitch nil :font "JetBrains Mono" :weight 'light :height 150) ; 190
;;  (set-face-attribute 'variable-pitch nil :font "Iosevka Aile" :weight 'light :height 0.8) ; 1.3
)

(if (daemonp)
    (add-hook 'after-make-frame-functions
	      (lambda (frame)
		;; (setq doom-modeline-icon t)
		(with-selected-frame frame
		  (efs/set-font-faces))))
    (efs/set-font-faces))
