DRONES_DIR = $(shell git config "borg.drones-directory" || echo "lib")

# Borg's init-file targets only compile files listed here; without this,
# `make build` compiles init.el but never the lisp/ modules.
INIT_FILES = init.el $(wildcard lisp/*.el)

-include $(DRONES_DIR)/borg/borg.mk

bootstrap-borg:
	@git submodule--helper clone --name borg --path $(DRONES_DIR)/borg \
        --url git@github.com:emacscollective/borg.git
	@cd $(DRONES_DIR)/borg; git symbolic-ref HEAD refs/heads/main
	@cd $(DRONES_DIR)/borg; git reset --hard HEAD
