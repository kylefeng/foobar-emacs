;;; init-org.el --- org-mode and org-roam -*- lexical-binding: t; -*-

(require 'org)
(require 'org-modern)
(require 'org-tidy)
(require 'org-download)

(dolist (face '(window-divider
                window-divider-first-pixel
                window-divider-last-pixel))
  (face-spec-reset-face face)
  (set-face-foreground face (face-attribute 'default :background)))

(set-face-background 'fringe (face-attribute 'default :background))


(with-eval-after-load 'org
  (defvar org-agenda-dir "gtd org files location")
  (setq-default org-agenda-dir (file-truename "~/development/org"))

  (setq-default org-directory (file-truename "~/development/org"))

  ;; Choose some fonts
  (set-face-attribute 'default nil :family "Iosevka")
  (set-face-attribute 'variable-pitch nil :family "Iosevka Aile")
  (set-face-attribute 'org-modern-symbol nil :family "Iosevka")

  (setq
    ;; Edit settings
    org-tags-column 0 
    org-fold-catch-invisible-edits 'show-and-error
    org-starup-indented t
    org-auto-align-tags nil
    org-special-ctrl-a/e t
    org-insert-heading-respect-content t

    ;; Org styling, hide markup etc.
    org-hide-emphasis-markers t
    org-pretty-entities t

    ;; Agenda styling
    org-agenda-tags-column 0
    org-agenda-block-separator ?─
    org-agenda-time-grid
    '((daily today require-timed)
      (800 1000 1200 1400 1600 1800 2000)
      " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")

    org-agenda-current-time-string
    "<- now ─────────────────────────────────────────────────"

    org-todo-keywords '((sequence "TODO(t!)" "ACTING(a!)" "|" "DONE(d!)" "CANCELED(c@/!)"))

    ;; agenda files
    org-agenda-files (directory-files-recursively org-agenda-dir "\\.org$")

    org-image-actual-width 600
    org-edit-src-content-indentation 0
    )

  ;; Ellipsis styling
  (setq org-ellipsis "…")
  (set-face-attribute 'org-ellipsis nil :inherit 'default :box nil)

  (setq org-agenda-file-note (expand-file-name "notes.org" org-agenda-dir))
  (setq org-agenda-file-task (expand-file-name "task.org" org-agenda-dir))
  (setq org-agenda-file-calendar (expand-file-name "calendar.org" org-agenda-dir))
  (setq org-agenda-file-finished (expand-file-name "finished.org" org-agenda-dir))
  (setq org-agenda-file-canceled (expand-file-name "canceled.org" org-agenda-dir))
  (setq org-roam-inbox-file (file-truename "~/org-roam/inbox.org"))

  (setq org-capture-templates
    '(
   ("t" "Todo" entry (file+headline org-agenda-file-task "Work")
     "* TODO [#B] %?\n  %i\n"
     :empty-lines 1)
    ("l" "Tolearn" entry (file+headline org-agenda-file-task "Learning")
      "* TODO [#B] %?\n  %i\n"
      :empty-lines 1)
    ("h" "Toplay" entry (file+headline org-agenda-file-task "Hobbies")
      "* TODO [#C] %?\n  %i\n"
      :empty-lines 1)
    ("I" "Inbox" entry (file+headline org-agenda-file-task "Inbox")
      "* TODO [#C] %?\n  %i\n"
      :empty-lines 1)
    ("o" "Todo_others" entry (file+headline org-agenda-file-task "Others")
      "* TODO [#C] %?\n  %i\n"
      :empty-lines 1)
    ("n" "Notes" entry (file+headline org-agenda-file-note "Quick notes")
      "* %?\n  %i\n %U"
      :empty-lines 1)
    ("i" "Ideas" entry (file+headline org-agenda-file-note "Quick ideas")
      "* %?\n  %i\n %U"
      :empty-lines 1)
    ("s" "Slipbox" entry (file org-roam-inbox-file) "* %?\n")
    ))

  (setq org-agenda-custom-commands
    '(
  ("w" . "任务安排")
  ("wa" "重要且紧急的任务" tags-todo "+PRIORITY=\"A\"")
  ("wb" "重要且不紧急的任务" tags-todo "-weekly-monthly-daily+PRIORITY=\"B\"")
  ("wc" "不重要且紧急的任务" tags-todo "+PRIORITY=\"C\"")
  ("W" "Weekly Review"
   ((stuck "") ;; review stuck projects as designated by org-stuck-projects
    (tags-todo "daily")
    (tags-todo "weekly")
    (tags-todo "work")
    (tags-todo "blog")
    (tags-todo "book")
    ))
  ))

  (setq org-refile-targets  '((org-agenda-file-finished :maxlevel . 1)
                              (org-agenda-file-note :maxlevel . 1)
                              (org-agenda-file-canceled :maxlevel . 1)
                              (org-agenda-file-task :maxlevel . 1))))

(with-eval-after-load 'org
  (global-org-modern-mode)
  (org-toggle-pretty-entities))

(defun org-insert-image ()
  (interactive)
  (let* ((buffer-name (buffer-name))
         (path (concat default-directory "images/"))
         (image-dir (concat path buffer-name "/"))
         (image-file (concat image-dir
                             (format-time-string "%Y%m%d_%H%M%S.png")))
         (counter 1))
    ;; 如果不存在 images 目录则创建
    (if (not (file-exists-p path))
        (mkdir path))

    ;; 如果 buffer 名称目录已存在，则递增计数直到找到可用的目录名
    (while (file-exists-p image-dir)
      (setq image-dir (concat path buffer-name "_" (number-to-string counter) "/"))
      (setq counter (1+ counter)))

    ;; 创建最终的图像目录
    (mkdir image-dir)

    ;; 执行 pngpaste 命令并将图像保存到指定目录
    (shell-command (concat "pngpaste " image-file))

    ;; 插入链接
    (org-insert-link nil (concat "file:" image-file) "")))

(defun foobar/org-jump-to-first-heading-same-level ()
  "Move to first sibling with same level."
  (interactive)
  (let ((p (point)))
    (while (progn (org-forward-heading-same-level -1)
                  (< (point) p))
      (setq p (point)))))

(defun foobar/org-jump-to-last-heading-same-level ()
  "Move to last sibling with same level."
  (interactive)
  (let ((p (point)))
    (while (progn (org-forward-heading-same-level 1)
                  (< p (point)))
      (setq p (point)))))

(add-hook 'dired-mode-hook 'org-download-enable)

;; add extensions
(add-to-list 'load-path (concat user-emacs-directory "lib/org-roam/extensions/"))

(require 'org-roam)
(require 'org-roam-dailies)

(setq org-roam-mode-sections '(org-roam-backlinks-section
                               org-roam-reflinks-section))

(setq org-roam-directory (file-truename "~/org-roam"))
(setq org-roam-dailies-directory "dailies/")
(setq org-roam-db-gc-threshold most-positive-fixnum)

(cl-defmethod org-roam-node-type ((node org-roam-node))
  "Return the TYTPE of NODE."
  (condition-case nil
      (file-name-nondirectory
       (directory-file-name
        (file-name-directory
         (file-relative-name (org-roam-node-file node) org-roam-directory))))
    (error "")))

(setq org-roam-node-display-template
      (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))

(add-to-list 'display-buffer-alist
             '("\\*org-roam\\*"
               (display-buffer-in-side-window)
               (side . right)
               (slot . 0)
               (window-width . 0.33)
               (window-height . fit-window-to-buffer)))

;; templates
(setq org-roam-capture-templates '(("m" "main" plain "%?"
                                    :if-new (file+head "main/${slug}.org"
                                                       "#+title: ${title}\n")
                                    :immediate-finish t
                                    :unnarrowed t)

                                   ("r" "reference" plain "%?"
                                    :if-new (file+head "reference/${slug}.org"
                                                       "#+title: ${title}\n")
                                    :immediate-finish t
                                    :unnarrowed t)

                                   ("a" "article" plain "%?"
                                    :if-new (file+head "articles/${slug}.org"
                                                       "#+title: ${title}\n")
                                    :immediate-finish t
                                    :unnarrowed t)))

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         "* %?"
         :target (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>\n"))))

(general-define-key "C-c n f" 'org-roam-node-find)
(general-define-key "C-c n i" 'org-roam-node-insert)
(general-define-key "C-c n c" 'org-roam-capture)
(general-define-key "C-c n l" 'org-roam-buffer-toggle)
(general-define-key "C-c n u" 'org-roam-ui-mode)


(with-eval-after-load 'org-roam
  (org-roam-db-autosync-mode))


(provide 'init-org)
