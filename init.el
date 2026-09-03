;;; init.el --- personal Emacs configuration entry point -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Hand-maintained module loader. Each feature area lives in its own file
;; under lisp/ and is required here in dependency order. init-startup must
;; come first — it defines the constants (*is-mac* etc.) and utilities
;; (foobar/add-auto-mode, proxy helpers) that later modules reference.

;; eval-and-compile: the byte compiler evaluates `require` forms but not
;; plain top-level forms, so batch compiles (borg's `make build`, flycheck)
;; need lisp/ on load-path at compile time too.
(eval-and-compile
  (add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory)))

(require 'init-startup)
(require 'init-ui)
(require 'init-evil)
(require 'init-enhancement)
(require 'init-programming)
(require 'init-org)
(require 'init-keybindings)
(require 'init-hydra)
(require 'init-misc)
(require 'init-ai)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; init.el ends here
