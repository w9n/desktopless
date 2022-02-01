.PHONY: build run dockerfiles pkgs base

build: base dockerfiles pkgs 

base:
	make -C ./tools/alpine

dockerfiles:
	make -C ./dockerfiles

pkgs:
	make -C ./pkg

update-alpine-tag:
	$(eval alpine := desktopless/alpine:$(shell cat tools/alpine/hash))
	./scripts/update-component-sha.sh --image $(alpine);

update-package-tags:
ifneq ($(LK_RELEASE),)
	$(eval tags := $(shell cd pkg; make show-tag | cut -d ':' -f1))
	$(eval image := :$(LK_RELEASE))
else
	$(eval tags := $(shell cd pkg; make show-tag))
	$(eval image := )
endif
	for img in $(tags); do \
		./scripts/update-component-sha.sh --image $${img}$(image); \
	done
