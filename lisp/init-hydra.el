;;; init-hydra.el --- hydra menus -*- lexical-binding: t; -*-

(require 'hydra)

(defhydra hydra-undo-tree (:hint nil)
  "
  _p_: undo _n_: redo _s_: save _l_: load  "
  ("p"  undo-tree-undo)
  ("n"  undo-tree-redo)
  ("s"  undo-tree-save-history)
  ("l"  undo-tree-load-history)
  ("u"  undo-tree-visualize "visualize" :color blue)
  ("q"  nil "quit" :color blue))

(global-set-key (kbd "C-x C-h u") 'hydra-undo-tree/body)

(defhydra hydra-multiple-cursors (:hint nil)
  "
   Up^^          Down^^       Miscellaneous      % 2(mc/num-cursors) cursor%s(if (> (mc/num-cursors) 1) \"s\" \"\")
  ------------------------------------------------------------------
  [_p_]  Prev   [_n_]  Next   [_l_] Edit lines [_0_] Insert numbers
  [_P_]  Skip   [_N_]  Skip   [_a_] Mark all   [_A_] Insert letters
  [_M-p_] Unmark  [_M-n_] Unmark  [_s_] Search   [_q_] Quit
  [_|_] Align with input CHAR    [Click] Cursor at point"
  ("l" mc/edit-lines :exit t)
  ("a" mc/mark-all-like-this :exit t)
  ("n" mc/mark-next-like-this)
  ("N" mc/skip-to-next-like-this)
  ("M-n" mc/unmark-next-like-this)
  ("p" mc/mark-previous-like-this)
  ("P" mc/skip-to-previous-like-this)
  ("M-p" mc/unmark-previous-like-this)
  ("|" mc/vertical-align)
  ("s" mc/mark-all-in-region-regexp :exit t)
  ("0" mc/insert-numbers :exit t)
  ("A" mc/insert-letters :exit t)
  ("<mouse-1>" mc/add-cursor-on-click)
  ;; Help with click recognition in this hydra
  ("<down-mouse-1>" ignore)
  ("<drag-mouse-1>" ignore)
  ("q" nil))
(global-set-key (kbd "C-x C-h m") 'hydra-multiple-cursors/body)


(provide 'init-hydra)
