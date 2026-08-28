;;; init-keybindings.el --- global key bindings -*- lexical-binding: t; -*-

(when *is-mac*
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'super))

(defun next-ten-lines ()
  "Move cursor to next 10 lines."
  (interactive)
  (forward-line 10))

(defun previous-ten-lines ()
  "Move cursor to previous 10 lines."
  (interactive)
  (forward-line -10))

(global-set-key (kbd "M-W") 'kill-region)        ; 交换 M-w 和 C-w，M-w 为剪切
(global-set-key (kbd "M-w") 'kill-ring-save)     ; 交换 M-w 和 C-w，C-w 为复制
(global-set-key (kbd "M-n") 'next-ten-lines)
(global-set-key (kbd "M-p") 'previous-ten-lines)


(provide 'init-keybindings)
