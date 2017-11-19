RUN_PARAM?=-r

default:
	./run.sh -s

image:
	docker build . --tag=wiin/desktopless

i3:
	./run.sh $(RUN_PARAM) -n i3-simple -- base i3 xserver

i3-docker:
	./run.sh $(RUN_PARAM) -n i3-docker -- base docker i3 xserver

i3-docker-cached:
	./run.sh $(RUN_PARAM) -n i3-docker-cached -- base docker i3 xserver docker-image-cache

clean:
	rm -f builds/*
