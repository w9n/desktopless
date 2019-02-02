DIRS = $(dir $(shell find . -maxdepth 2 -mindepth 2 -type f -name Dockerfile))
.PHONY: push force-push build forcebuild show-tag clean

OPTIONS ?=

build:
	@set -e; for d in $(DIRS); do docker build $(OPTIONS) "$$d" -t wiin/$$(basename $$d) ; done
