;;; init-programming.el --- language modes, project, and LSP -*- lexical-binding: t; -*-
;;; commentary:
;;; code:
(require 'yasnippet)

(yas-reload-all)

(defun company-mode/backend-with-yas (backend)
  (if (and (listp backend) (member 'company-yasnippet backend))
   backend
   (append (if (consp backend) backend (list backend))
  '(:with company-yasnippet))))
(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

(add-hook 'prog-mode-hook 'yas-minor-mode)
(add-hook 'yas-minor-mode-hook
   (lambda ()
     ;; unbind <TAB> completion
     (define-key yas-minor-mode-map [(tab)]    nil)
     (define-key yas-minor-mode-map (kbd "TAB")  nil)
     (define-key yas-minor-mode-map (kbd "<tab>") nil)
     (keymap-set yas-minor-mode-map "S-<tab>" 'yas-expand)))

(require 'yasnippet-snippets)


;;;;;;;;;;;;;;;;;;;;;;;;;; project

(require 'projectile)

(setq projectile-mode-line "Projectile")
(setq projectile-track-known-projects-automatically nil)
(setq projectile-comletion-system 'ivy)

(global-set-key (kbd "C-c p") 'projectile-command-map)

(require 'counsel-projectile)
(counsel-projectile-mode)

(require 'treemacs)

;; 配置 treemacs
(with-eval-after-load 'treemacs
  ;; Explicit require: the mode is only reachable via treemacs's generated
  ;; autoloads, which bare batch environments (flycheck) never load.
  (require 'treemacs-tag-follow-mode)
  (treemacs-tag-follow-mode))

;; 全局快捷键绑定
(global-set-key (kbd "M-0")  #'treemacs-select-window)
(global-set-key (kbd "C-x t 1") #'treemacs-delete-other-windows)
(global-set-key (kbd "C-x t t") #'treemacs)
(global-set-key (kbd "C-x t B") #'treemacs-bookmark)
(global-set-key (kbd "C-x t M-t") #'treemacs-find-tag)

;; treemacs-mode-map 快捷键绑定
(with-eval-after-load 'treemacs
  (define-key treemacs-mode-map (kbd "/") #'treemacs-advanced-helpful-hydra))

(require 'magit)

(with-eval-after-load 'magit
  (magit-add-section-hook 'magit-status-sections-hook
                          'magit-insert-modules
                          'magit-insert-stashes
                          'append))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; lsp

(require 'lsp-mode)
(require 'lsp-ui)
(require 'lsp-ivy)

;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
(setq lsp-keymap-prefix "C-c l")
(setq lsp-file-watch-threshold 500)
(setq lsp-headerline-breadcrumb-enable t)

(add-hook 'c-mode-hook #'lsp-deferred)
(add-hook 'java-mode-hook #'lsp-deferred)
(add-hook 'js-mode-hook #'lsp-deferred)
(add-hook 'python-mode-hook #'lsp-deferred)
(add-hook 'web-mode-hook #'lsp-deferred)
(add-hook 'html-mode-hook #'lsp-deferred)
(add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)

(require 'go-mode)
(add-hook 'go-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(require 'haskell-mode)

(require 'geiser)
(require 'geiser-guile)

(require 'python)

(add-to-list 'auto-mode-alist
             '("\\.py\\'" . python-mode))

(setq python-shell-interpreter "python3")

(require 'pyvenv)

(add-hook 'python-mode-hook 'pyvenv-mode)

(require 'poetry)

(require 'lsp-pyright)
(add-hook 'python-mode-hook #'lsp-deferred)

(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook 'emmet-mode)
(add-hook 'rjsx-mode-hook 'emmet-mode)

(foobar/add-auto-mode 'web-mode
                      "\\.\\(cmp\\|app\\|page\\|component\\|wp\\|vue\\|tmpl\\|php\\|module\\|inc\\|hbs\\|tpl\\|[gj]sp\\|as[cp]x\\|erb\\|mustache\\|djhtml\\|ftl\\|[rp]?html?\\|xul?\\|eex?\\|xml?\\|jst\\|ejs\\|erb\\|rbxlx\\|plist\\)\\'")

(with-eval-after-load 'web-mode
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-paring t)
  (setq web-mode-auto-close-style 2)
  (setq web-mode-enable-css-colorization t)
  )

(foobar/add-auto-mode 'js-mode
                      "\\.ja?son\\'"
                      "\\.pac\\'"
                      "\\.jshintrc\\'"
                      )

;; javascript
(foobar/add-auto-mode 'js2-mode "\\.m?js\\(\\.erb\\)?\\'")

;; JSX
(foobar/add-auto-mode 'rjsx-mode
                      "\\.[tj]sx\\'"
                      "components\\/.*\\.js\\'")

(require 'yaml-mode)
(foobar/add-auto-mode 'yaml-mode
                      "\\.yml\\'"
                      "\\.yaml\\'")


(provide 'init-programming)
;;; init-programming.el ends here
