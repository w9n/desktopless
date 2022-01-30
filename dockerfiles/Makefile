DIRS = $(dir $(shell find . -maxdepth 2 -mindepth 2 -type f -name Dockerfile))
.PHONY: default push force-push build forcebuild show-tag clean

OPTIONS ?=

default: build push

build:
	@set -e; for d in $(DIRS); do docker build $(OPTIONS) "$$d" -t desktopless/$$(basename $$d) ; done

push:
	@set -e; for d in $(DIRS); do docker push $(OPTIONS) desktopless/$$(basename $$d) ; done
