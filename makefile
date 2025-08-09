SCRIPTS_DIR := ./scripts

.PHONY: start build stop

start:
	@$(SCRIPTS_DIR)/start.sh

build:
	@$(SCRIPTS_DIR)/build.sh

stop:
	@$(SCRIPTS_DIR)/stop.sh
