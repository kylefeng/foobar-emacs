;;; init-ui.el --- UI: modeline, theme, fonts, icons -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(set-frame-width (selected-frame) 180)
(set-frame-height (selected-frame) 60)

(global-display-line-numbers-mode t)
(column-number-mode 1)

;; 相对行数方便跨行操作计数
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-width 3)
(setq display-line-numbers-widen t)

;; turn on good-scroll
(require 'good-scroll)
(add-hook 'after-init-hook #'good-scroll-mode)

(require 'smart-mode-line)

(setq sml/no-confirm-load-theme t)
(setq rm-blacklist
  (format "^ \\(%s\\)$"
   (mapconcat #'identity
    '("Projectile.*" "company.*"  "Undo-Tree" "counsel" "ivy" "yas" "WK" "snipe")
     "\\|")))
(sml/setup)
(sml/apply-theme 'respectful)

(load-theme 'modus-operandi :no-confirm)
;;(load-theme 'dracula :no-confirm)

(when (display-graphic-p)
  (require 'all-the-icons))

(defun set-font (english chinese english-size chinese-size)
  "Set Chinese, English font and size."
  (set-face-attribute 'default nil :font
                      (format "%s:pixelsize=%d"  english english-size))
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font) charset
                      (font-spec :family chinese :size chinese-size))))

(add-to-list 'after-make-frame-functions
     (lambda (new-frame)
       (select-frame new-frame)
       (when (display-graphic-p)
 (set-font "Maple Mono NF CN" "Maple Mono NF CN" 13 13))))

(when (display-graphic-p)
    (set-font "Maple Mono NF CN" "Maple Mono NF CN" 13 13))

(require 'rainbow-delimiters)
(add-hook 'prog-mod-hook 'rainbow-delimiters-mode)


(provide 'init-ui)
;;; init-ui.el ends here
