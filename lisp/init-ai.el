;;; init-ai.el --- gptel AI integration -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'setup)
(require 'gptel)

(setup gptel
  (setopt
   gptel-model 'gpt-5.3
   gptel-backend (gptel-make-openai "Monica"
                  :host "openapi.monica.im"
                  :protocol "https"
                  :endpoint "/v1/chat/completions"
                  :stream t
                  :models '("gpt-4o"))
   gptel-api-key #'gptel-api-key-from-auth-source
   gptel-proxy "127.0.0.1:64477"))

(provide 'init-ai)
;;; init-ai.el ends here
