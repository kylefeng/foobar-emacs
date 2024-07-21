;; -*- lexical-binding: t; -*-
(setq package-enable-at-startup nil)

(add-to-list 'load-path (expand-file-name "lib/borg" user-emacs-directory))
(require 'borg)
(borg-initialize)


(defconst *is-mac* (eq system-type 'darwin))
(defconst *is-linux* (eq system-type 'gnu/linux))
(defconst *is-windows* (or (eq system-type 'ms-dos)
			   (eq system-type 'windows-nt)))

(defconst *spell-check-support-enabled* nil)
