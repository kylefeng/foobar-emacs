;;; init-enhancement.el --- completion, search, and editing enhancements -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'setup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; which key
(require 'which-key)
(which-key-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; flycheck
(require 'flycheck)

(setup flycheck
  ;; Inherit the session load-path so elisp files requiring borg drones (lib/)
  ;; can be checked; the default bare subprocess can't resolve them.
  (setopt flycheck-emacs-lisp-load-path 'inherit)
  )


;; *scratch* (lisp-interaction-mode) derives from prog-mode, but no checker can
;; run there — the emacs-lisp checker is gated on trusted-content (Emacs 30+,
;; CVE-2024-53920) and scratch's temp file is never trusted — so enabling
;; flycheck there only produces a startup warning.
(add-hook 'prog-mode-hook
          (lambda ()
            (unless (derived-mode-p 'lisp-interaction-mode)
              (flycheck-mode 1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ace-window
(require 'ace-window)
(setup ace-window
  (:global
   "M-o" ace-window
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; amx
(require 'amx)
(amx-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; mwim
(require 'mwim)
(setup mwim
  (:global
   "C-a" mwim-beginning-of-code-or-line
   "C-e "mwim-end-of-code-or-line
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; mwim
(require 'marginalia)
(setup marginalia-mode
  (:hook
   (lambda ()
     (keymap-set minibuffer-local-map
      "M-a" 'marginalia-cycle)))
  (marginalia-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; highlight-symbol
(require 'highlight-symbol)
(setup highlight-symbol-mode
  (:global
   "<f3>" highlight-symbol
   )
  (highlight-symbol-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; keyfreq
(require 'keyfreq)
(setup keyfreq-mode
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; general
(require 'general)


;;;;;;;;;;;;;;;;;;;;;; ivy / counsel / swiper
(require 'ivy)
(require 'counsel)
(require 'swiper)

(setup ivy-mode
  (setopt
   ivy-use-virtual-buffers t
   ivy-initial-inputs-alist nil
   ivy-count-format "(%d/%d) "
   ivy-re-builders-alist '((t . ivy--regex-ignore-order))
   search-default-mode #'char-fold-to-regexp)
   (:global
    ;; ivy-based interface to standards commands
    "C-s" swiper-isearch
    "M-x" counsel-M-x

    ;; ivy KBD
    "C-x b" ivy-switch-buffer
    "C-c v" ivy-push-view
    "C-c s" ivy-switch-view
    "C-c V" ivy-pop-view
    )
   (:hook-into after-init-hook))

(setup counsel-mode
  (:global
   "C-x C-SPC" counsel-mark-ring
   "C-x C-f" counsel-find-file
   "C-c f" counsel-recentf
   "C-c g" counsel-git
   "C-c j" counsel-git-grep
   )
  (:hook-into after-init-hook))

(setup swiper-mode
  (setopt
   swiper-action-recentf t
   swiper-include-line-number-in-search t
   ))

(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

;;;;;;;;;;;;;;;;;;;;;; company
(require 'company)
(require 'company-box)

(setup company-mode
  (setopt
   company-minimum-prefix-length 1
   company-selection-wrap-around t
   company-show-quick-access t
   company-backends '(company-capf company-files company-keywords)
   company-idle-delay 0.2
   company-transformers '(company-sort-by-occurrence)

   ;; Newer company defaults to the posframe-based childframe frontend on GUI
   ;; frames, but posframe isn't a drone; pin the pseudo-tooltip set so
   ;; company-box-mode can swap it for its own frontend as it expects to.
   company-frontends '(company-pseudo-tooltip-unless-just-one-frontend
                       company-preview-if-just-one-frontend
                       company-echo-metadata-frontend)
   ))

;; Upstream deprecation nag: C-h in the popup warns and pushes M-h/M-g.
;; Keep doc-on-C-h, just without the warning.
(define-key company-active-map (kbd "C-h") #'company-show-doc-buffer)

;; Must be quoted: the bare symbol is read as a variable (nil for globalized
;; minor modes), which injects a literal nil into the hook and run-hooks
;; aborts on it at startup.
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'company-mode-hook 'company-box-mode)

;;;;;;;;;;;;;;;;;;;;;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode 1)
(setq undo-tree-auto-save-history nil)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/toggle-cursor-on-click)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; helpful
(require 'helpful)
(setup helpful-mode
  (:global
   ;; Note that the built-in `describe-function' includes both functions
   ;; and macros. `helpful-function' is functions only, so we provide
   ;; `helpful-callable' as a drop-in replacement.
   "C-h f" helpful-callable
   "C-h v" helpful-variable
   "C-h k" helpful-key
   "C-h x" helpful-command

   ;; Lookup the current symbol at point. C-c C-d is a common keybinding
   ;; for this in lisp modes.
   "C-c C-d" helpful-at-point

   ;; Look up *F*unctions (excludes macros).
   ;;
   ;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
   ;; already links to the manual, if a function is referenced there.
   "C-h F" helpful-function)

  (with-eval-after-load 'counsel
    (setopt counsel-describe-function-function #'helpful-callable)
    (setopt counsel-describe-variable-function #'helpful-variable))
  )



(provide 'init-enhancement)
;;; init-enhancement.el ends here
