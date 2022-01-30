.PHONY: build run dockerfiles pkgs base

build: base dockerfiles pkgs 

base:
	make -C ./tools/alpine

dockerfiles:
	make -C ./dockerfiles

pkgs:
	make -C ./pkg
