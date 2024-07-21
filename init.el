;; -*- lexical-binding: t; -*-

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

(setq ring-bell-function 'ignore)
(setq inhibit-startup-screen t)

;; no file backup
(setq make-backup-files nil)

;; 自动补全括号
(electric-pair-mode t)

;; make ibuffer default
(defalias 'list-buffers 'ibuffer)

;; 自动刷新 buffer
(global-auto-revert-mode t)

;; 选中文本后输入会替换文本
(delete-selection-mode t)

(defun mp-elisp-mode-eval-buffer ()
  (interactive)
  (message "Evaluated buffer")
  (eval-buffer))

(define-key emacs-lisp-mode-map (kbd "C-c C-c") #'mp-elisp-mode-eval-buffer)
(define-key lisp-interaction-mode-map (kbd "C-c C-c") #'mp-elisp-mode-eval-buffer)

(defalias 'yes-or-no-p 'y-or-n-p)

(tool-bar-mode -1)
(scroll-bar-mode -1)

(set-frame-width (selected-frame) 180)
(set-frame-height (selected-frame) 60)

(global-display-line-numbers-mode t)

(setq display-line-numbers-type 'relative)
