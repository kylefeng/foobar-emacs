;;; init-enhancement.el --- completion, search, and editing enhancements -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; exec-path-from-file
(require 'exec-path-from-shell)
(exec-path-from-shell-initialize)


(require 'which-key)
(which-key-mode)

(require 'flycheck)
(add-hook 'prog-mode-hook 'flycheck-mode)

;; ace-window
(require 'ace-window)
(global-set-key (kbd "M-o") 'ace-window)

(require 'amx)
(amx-mode)

(require 'mwim)
(global-set-key (kbd "C-a") 'mwim-beginning-of-code-or-line)
(global-set-key (kbd "C-e") 'mwim-end-of-code-or-line)

(require 'marginalia)
(marginalia-mode)
(add-hook 'marginalia-mode-hook
   (lambda ()
     (keymap-set minibuffer-local-map
      "M-a" 'marginalia-cycle)))

(require 'highlight-symbol)
(highlight-symbol-mode 1)
(global-set-key (kbd "<f3>") 'highlight-symbol)

(require 'general)

(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

(require 'helpful)

;; Note that the built-in `describe-function' includes both functions
;; and macros. `helpful-function' is functions only, so we provide
;; `helpful-callable' as a drop-in replacement.
(global-set-key (kbd "C-h f") #'helpful-callable)

(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)
(global-set-key (kbd "C-h x") #'helpful-command)

;; Lookup the current symbol at point. C-c C-d is a common keybinding
;; for this in lisp modes.
(global-set-key (kbd "C-c C-d") #'helpful-at-point)

;; Look up *F*unctions (excludes macros).
;;
;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
;; already links to the manual, if a function is referenced there.
(global-set-key (kbd "C-h F") #'helpful-function)

(setq counsel-describe-function-function #'helpful-callable)
(setq counsel-describe-variable-function #'helpful-variable)


;;;;;;;;;;;;;;;;;;;;;; ivy / counsel / swiper
(require 'ivy)
(require 'counsel)
(require 'swiper)

(setq ivy-use-virtual-buffers t)
(setq ivy-initial-inputs-alist nil)
(setq ivy-count-format "(%d/%d) ")
(setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
(setq search-default-mode #'char-fold-to-regexp)

;; ivy-based interface to standards commands
(keymap-global-set "C-s" #'swiper-isearch)
(keymap-global-set "M-x" #'counsel-M-x)

;; ivy KBD
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "C-c v") 'ivy-push-view)
(global-set-key (kbd "C-c s") 'ivy-switch-view)
(global-set-key (kbd "C-c V") 'ivy-pop-view)

(add-hook 'after-init-hook 'ivy-mode)


;; counsel KBD
(global-set-key (kbd "C-x C-SPC") 'counsel-mark-ring)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-c f") 'counsel-recentf)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(add-hook 'after-init-hook 'counsel-mode)

(setq swiper-action-recentf t)
(setq swiper-include-line-number-in-search t)

;; swiper KBD

;;;;;;;;;;;;;;;;;;;;;; company
(require 'company)
(setq company-minimum-prefix-length 1)
(setq company-selection-wrap-around t)
(setq company-show-quick-access t)
(setq company-backends '(company-capf company-files company-keywords))
(setq company-idle-delay 0.2)
(setq company-transformers '(company-sort-by-occurrence))
(add-hook 'after-init-hook global-company-mode)

(require 'company-box)
(add-hook 'company-mode-hook 'company-box-mode)

(require 'undo-tree)
(global-undo-tree-mode 1)

(setq undo-tree-auto-save-history nil)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/toggle-cursor-on-click)


(provide 'init-enhancement)
;;; init-enhancement.el ends here
