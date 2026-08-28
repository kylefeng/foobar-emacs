;;; early-init.el --- early initialization, loaded before init.el -*- lexical-binding: t; -*-

;; Adjust garbage collection thresholds during startup, and thereafter
(setq gc-cons-threshold most-positive-fixnum)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))

;; Process performance tuning
(setq read-process-output-max (* 4 1024 1024))
(setq process-adaptive-read-buffering nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; START fork from - https://github.com/jamescherti/minimal-emacs.d/blob/main/early-init.el

(defvar minimal-emacs-frame-title-format "%b – Emacs"
  "Template for displaying the title bar of visible and iconified frame.")

;; Prefer loading newer compiled files
(setq load-prefer-newer t)

;; Reduce rendering/line scan work by not rendering cursors or regions in
;; non-focused windows.
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

;; Disable warnings from the legacy advice API. They aren't useful.
(setq ad-redefinition-action 'accept)

;; Ignore warnings about "existing variables being aliased".
(setq warning-suppress-types '((defvaralias) (lexical-binding)))

;; Don't ping things that look like domain names.
(setq ffap-machine-p-known 'reject)

;; Font compacting can be very resource-intensive, especially when rendering
;; icon fonts on Windows. This will increase memory usage.
(setq inhibit-compacting-font-caches t)


(setq frame-title-format minimal-emacs-frame-title-format
      icon-title-format minimal-emacs-frame-title-format)
;; END fork from - https://github.com/jamescherti/minimal-emacs.d/blob/main/early-init.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; init borg
(add-to-list 'load-path (expand-file-name "lib/borg" user-emacs-directory))
(require 'borg)

(setq package-enable-at-startup nil)


(setq borg-rewrite-urls-alist
  '(("git@github.com:" . "https://github.com/")
    ("git@gitlab.com:" . "https://gitlab.com/")))
(borg-initialize)

;; 自定义 custom file
(defvar minimal-emacs-frame-title-format "%b – Emacs"
  "Template for displaying the title bar of visible and iconified frame.")

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load-file custom-file))
