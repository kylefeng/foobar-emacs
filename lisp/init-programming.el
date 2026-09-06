;;; init-programming.el --- language modes, project, and LSP -*- lexical-binding: t; -*-
;;; commentary:
;;; code:

(require 'setup)
(require 'yasnippet)
(require 'yasnippet-snippets)

(defun company-mode/backend-with-yas (backend)
  (if (and (listp backend) (member 'company-yasnippet backend))
   backend
   (append (if (consp backend) backend (list backend))
  '(:with company-yasnippet))))


(setup yasnippet
  (yas-reload-all)
  (setopt
   company-backends
   (mapcar #'company-mode/backend-with-yas company-backends))
  )

(setup yas-minor-mode
  (:hook-into prog-mode)
  (:hook (lambda ()
           ;; unbind <TAB> completion
           (define-key yas-minor-mode-map [(tab)] nil)
           (define-key yas-minor-mode-map (kbd "TAB") nil)
           (define-key yas-minor-mode-map (kbd "<tab>") nil)
           (keymap-set yas-minor-mode-map "S-<tab>" 'yas-expand))))


;;;;;;;;;;;;;;;;;;;;;;;;;; project

(require 'projectile)

(setup projectile
  ;; Borg drones are 86 git submodules, and alien indexing shells out to
  ;; `git ls-files' + `git submodule foreach' inside each drone on EVERY
  ;; project switch (~11s of synchronous `shell-command' calls, UI frozen).
  ;; We never want lib/ files indexed anyway (.projectile's `-/lib/' is
  ;; silently ignored by alien mode), so disable submodule listing entirely.
  (setq projectile-git-submodule-command nil)
  (setopt projectile-mode-line "Projectile"
          projectile-track-known-projects-automatically nil
          projectile-comletion-system 'ivy
          )
  (:global "C-c p" #'projectile-command-map)
  )

(require 'counsel-projectile)
(counsel-projectile-mode)

;; projectile v2.8 removed the `projectile-known-projects' FUNCTION (keeping
;; only the variable of the same name); counsel-projectile still calls it.
(defun projectile-known-projects () projectile-known-projects)


;;;;;;;;;;;;;;;;;;;;;;;;;; Treemacs

(require 'treemacs)

(setup treemacs
  ;; Explicit load: the mode is only reachable via treemacs's generated
  ;; autoloads, which bare batch environments (flycheck) never load.
  (:also-load treemacs-tag-follow-mode)
  (treemacs-tag-follow-mode)
  (:global "M-0" #'treemacs-select-window
           "C-x t 1" #'treemacs-delete-other-windows
           "C-x t t" #'treemacs
           "C-x t B" #'treemacs-bookmark
           "C-x t M-t" #'treemacs-find-tag)
  ;; treemacs-mode-map lives in treemacs-mode.el, which only loads when the
  ;; first treemacs buffer opens, so bind after that feature is in.
  (:bind-into treemacs-mode
    "/" #'treemacs-advanced-helpful-hydra))

;;;;;;;;;;;;;;;;;;;;;;;;;; Magit
(require 'magit)

(setup magit
  (magit-add-section-hook 'magit-status-sections-hook
                          'magit-insert-modules
                          'magit-insert-stashes
                          'append))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; lsp

(require 'lsp-mode)
(require 'lsp-ui)
(require 'lsp-ivy)

(setup lsp-mode
  (setopt lsp-keymap-prefix "C-c l")
  (setopt lsp-file-watch-threshold 500)
  (setopt lsp-headerline-breadcrumb-enable t)
  )

;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
(add-hook 'c-mode-hook #'lsp-deferred)
(add-hook 'java-mode-hook #'lsp-deferred)
(add-hook 'js-mode-hook #'lsp-deferred)
(add-hook 'python-mode-hook #'lsp-deferred)
(add-hook 'web-mode-hook #'lsp-deferred)
(add-hook 'html-mode-hook #'lsp-deferred)
(add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; go
(require 'go-mode)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))


(setup go-mode
  (:hook
   lsp-deferred
   lsp-go-install-save-hooks))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;; haskell
(require 'haskell-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; scheme
(require 'geiser)
(require 'geiser-guile)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; python
(require 'python)
(require 'pyvenv)
(require 'poetry)
(require 'lsp-pyright)

(setup python-mode
  (setopt python-shell-interpreter "python3")
  (:hook
   pyenv-mode
   lsp-deferred
   ))


(add-to-list 'auto-mode-alist
             '("\\.py\\'" . python-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; emmet-mode
(require 'web-mode)
(require 'emmet-mode)


(foobar/add-auto-mode
 'web-cmp
 (concat
  "\\."
  "\\(mode\\|app\\|page\\|component\\|"
  "wp\\|vue\\|tmpl\\|php\\|module\\|inc\\|"
  "hbs\\|tpl\\|[gj]sp\\|as[cp]x\\|erb\\|"
  "mustache\\|djhtml\\|ftl\\|[rp]?html?\\|xul?\\|"
  "eex?\\|xml?\\|jst\\|ejs\\|erb\\|rbxlx\\|plist\\)\\'"
  ))

(foobar/add-auto-mode 'js-mode
                      "\\.ja?son\\'"
                      "\\.pac\\'"
                      "\\.jshintrc\\'")

;; javascript
(foobar/add-auto-mode 'js2-mode "\\.m?js\\(\\.erb\\)?\\'")

;; JSX
(foobar/add-auto-mode 'rjsx-mode
                      "\\.[tj]sx\\'"
                      "components\\/.*\\.js\\'")


(setup emmet-mode
  (:hook-into
   sgml-mode-hook
   web-mode-hook
   css-mode-hook
   rjsx-mode-hook
   ))

(setup web-mode
  (with-eval-after-load 'web-mode
    (setopt web-mode-enable-auto-closing t)
    (setopt web-mode-enable-auto-paring t)
    (setopt web-mode-auto-close-style 2)
    (setopt web-mode-enable-css-colorization t))
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;; yaml-mode
(require 'yaml-mode)
(foobar/add-auto-mode 'yaml-mode
                      "\\.yml\\'"
                      "\\.yaml\\'")


(provide 'init-programming)
;;; init-programming.el ends here
