
(add-to-list 'load-path (expand-file-name "./package-download/"))

(add-to-list 'load-path (expand-file-name "./package-download/origami.el/"))
(require 'origami)

(global-origami-mode)

(keymap-global-set "C-=" 'origami-toggle-all-nodes)
(keymap-global-set "C--" 'origami-previous-fold)
(keymap-global-set "C-+" 'origami-next-fold)
(keymap-global-set "C-<backspace>" 'origami-toggle-node)
