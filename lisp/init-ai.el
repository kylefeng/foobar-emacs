;;; init-ai.el --- gptel AI integration -*- lexical-binding: t; -*-

(require 'gptel)

(setq
 gptel-model "gpt-4o"
 gptel-backend (gptel-make-openai "Monica"
  :host "openapi.monica.im"
  :protocol "https"
  :endpoint "/v1/chat/completions"
  :stream t
  :models '("gpt-4o")))

(setq gptel-api-key #'gptel-api-key-from-auth-source)

(setq gptel-proxy "127.0.0.1:64477")

(provide 'init-ai)
