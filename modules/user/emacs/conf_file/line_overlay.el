
(setq list-eq-line nil)

(defun line-length (char-point)
  "Length of the Nth line."
  (save-excursion
    (goto-char char-point)
    (- (line-end-position) (line-beginning-position))))

(defun fill-ov (ov)
  (overlay-put ov 'before-string (make-string (- (- (window-total-width (get-buffer-window (overlay-buffer ov))) (line-length (overlay-start ov))) 6) ?=))
  (overlay-put ov 'modification-hooks (list 'del-ov))
  (overlay-put ov 'invisible t))

(defun fill-all-ov (frame)
  (mapcar 'fill-ov list-eq-line))

(add-to-list 'window-size-change-functions 'fill-all-ov)

(defun add-eq-line ()
  (interactive)
  (add-to-list 'list-eq-line (make-overlay (- (point) 2) (point)))
  (fill-all-ov 0))

(defun delete-eq-ov (ov)
  (when (equal (overlay-start ov) (point))
    (setq list-eq-line (delete ov list-eq-line))
    (delete-overlay ov)))

(defun delete-eq-line ()
  (interactive)
  (mapcar 'delete-eq-ov list-eq-line))

(defun clear-eq-line ()
  (interactive)
  (mapcar 'delete-overlay list-eq-line)
  (setq list-eq-line nil))

(defun del-ov (ov after d f &optional size)
  (setq list-eq-line (delete ov list-eq-line))
  (delete-overlay ov))

(defun add-eq-line-pattern-point ()
  (interactive)
  (setq tmppoint (point))
  (beginning-of-buffer)
  (clear-eq-line)
  (setq tmp (re-search-forward "==$" nil t 1))
  (while tmp
    (goto-char tmp)
    ;(delete-eq-line)
    (add-eq-line)
    (setq tmp (re-search-forward "==$" nil t 1)))
  ;(end-of-buffer)
  (goto-char tmppoint))

(defun add-eq-line-change-fnc-aux (d f size-before)
  (interactive)
  (setq tmppoint (point))
  (setq pos d)
  (when (< pos 2) (setq pos 2))
  (while (< pos f)
    (when (and (= (char-after pos) 10) (= (char-after (- pos 1)) ?=) (= (char-after (- pos 2)) ?=))
      (goto-char pos)
      (add-eq-line))
    (setq pos (+ pos 1)))
  (goto-char tmppoint))

(defun add-eq-line-change-fnc (d f size-before)
  (interactive)
  (when (= size-before 0) (add-eq-line-change-fnc-aux d f size-before)))



(add-hook 'after-change-functions 'add-eq-line-change-fnc)

;(add-hook 'emacs-lisp-mode-hook 'add-eq-line-pattern-point)
(add-hook 'find-file-hook 'add-eq-line-pattern-point)

(keymap-global-set "C-x ù" 'add-eq-line-pattern-point)
(keymap-global-set "C-x %" 'clear-eq-line)
