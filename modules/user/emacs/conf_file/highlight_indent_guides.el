
(unless (package-installed-p 'highlight-indent-guides)
  (package-install 'highlight-indent-guides))
(require 'highlight-indent-guides)

(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

;(custom-set-variables '(highlight-indent-guides-method 'character)
;                      '(highlight-indent-guides-responsive 'top)
;		      '(highlight-indent-guides-auto-enabled nil)
;                      '(highlight-indent-guides-character ?|))

(custom-set-variables '(highlight-indent-guides-method 'bitmap)
                      '(highlight-indent-guides-responsive 'top)
		      '(highlight-indent-guides-auto-enabled nil)
		      '(highlight-indent-guides-bitmap-function 'highlight-indent-guides--bitmap-line))

(set-face-foreground 'highlight-indent-guides-character-face "black")
(set-face-foreground 'highlight-indent-guides-top-character-face "darkgrey")
