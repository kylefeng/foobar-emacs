;;; env.el --- Summary
;;; Commentary:
;;; Code:
;;; -*- lexical-binding: t -*-

(defvar doom-env-deny '()
  "Environment variables to omit from envvar files.

Each string is a regexp, matched against variable names to omit from
`doom-env-file'.")

(defvar doom-env-allow '()
  "Environment variables to include in envvar files.

This overrules `doom-env-deny'. Each string is a regexp, matched against
variable names to omit from `doom-env-file'.")

(setq env-file (expand-file-name "env" user-emacs-directory))
(delete-file env-file)

(with-temp-file env-file
  (let (
	(rpartial (lambda (&rest args)
		    (lambda (&rest pre-args)
		      (apply #'string-match-p (append pre-args args))))))
    (insert "(")
    (dolist (env process-environment)
      (catch 'skip
	(let* (
	       (var (car (split-string env "=")))
	       (pred (funcall rpartial var))
	       )
	  (when (seq-find pred doom-env-deny)
	    (if (seq-find pred doom-env-allow)
		(message "cli:env allow %s" var)
	      (message "cli:env deny %s" var)
	      (throw 'skip t)))
	  (insert (prin1-to-string env) "\n "))))
    (insert ")"))
  )

;;; (provide 'env)
;;; env.el ends here
