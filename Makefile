.PHONY: build run dockerfiles pkgs

build: dockerfiles pkgs

dockerfiles:
	make -C ./dockerfiles

pkgs:
	make -C ./pkg
