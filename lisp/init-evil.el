;;; init-evil.el --- evil, evil-surround, evil-snipe -*- lexical-binding: t; -*-

(require 'evil)
(require 'evil-surround)
(require 'evil-visualstar)

(evil-mode 1)
(global-evil-visualstar-mode 1)
(global-evil-surround-mode 1)

(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "TAB") nil)
  (define-key evil-motion-state-map (kbd "C-e") nil))

(setq evil-want-C-i-jump nil)

(evil-set-undo-system 'undo-redo)

;; {{ @see https://github.com/timcharper/evil-surround for tutorial
(run-with-idle-timer 2 nil #'global-evil-surround-mode)
(with-eval-after-load 'evil-surround
(defun evil-surround-prog-mode-hook-setup ()
  "Set up surround shortcuts."
  (cond
   ((memq major-mode '(sh-mode))
    (push '(?$ . ("$(" . ")")) evil-surround-pairs-alist))
   (t
    (push '(?$ . ("${" . "}")) evil-surround-pairs-alist)))

  (when (memq major-mode '(org-mode))
    (push '(?\[ . ("[[" . "]]")) evil-surround-pairs-alist)
    (push '(?= . ("=" . "=")) evil-surround-pairs-alist))

  (when (memq major-mode '(emacs-lisp-mode))
    (push '(?\( . ("( " . ")")) evil-surround-pairs-alist)
    (push '(?` . ("`" . "'")) evil-surround-pairs-alist))

  (when (or (derived-mode-p 'js-mode)
            (memq major-mode '(typescript-mode web-mode)))
    (push '(?j . ("JSON.stringify(" . ")")) evil-surround-pairs-alist)
    (push '(?> . ("(e) => " . "(e)")) evil-surround-pairs-alist))

    ;; generic
    (push '(?/ . ("/" . "/")) evil-surround-pairs-alist))
  (add-hook 'prog-mode-hook 'evil-surround-prog-mode-hook-setup))
;; }}

;; {{ For example, press `viW*`
(setq evil-visualstar/persistent t)
(run-with-idle-timer 2 nil #'global-evil-visualstar-mode)
;; }}

(require 'evil-snipe)

(evil-snipe-mode +1)
(evil-snipe-override-mode +1)

;; fix conflict
(add-hook 'magit-mode-hook 'turn-off-evil-snipe-override-mode)


(provide 'init-evil)
