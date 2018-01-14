default:
	./run.sh

image:
	docker build dockerfiles/desktopless --tag=wiin/desktopless

i3:
	./run.sh init.sh --build --libvirt --name i3-simple yml/base.yml yml/i3 yml/xserver.yml

i3-docker:
	./run.sh init.sh --build --libvirt --name i3-docker yml/base.yml yml/docker.yml yml/i3.yml yml/xserver.yml

i3-docker-cached:
	./run.sh init.sh --build --libvirt --name i3-docker-cached yml/base.yml yml/docker.yml yml/i3.yml yml/xserver.yml yml/docker-image-cache.yml

i3-docker-skopeo-cached:
	./run.sh init.sh --libvirt --name i3-docker-cached yml/base.yml yml/docker.yml yml/i3.yml yml/xserver.yml yml/docker-skopeo-image-cache.yml

clean:
	rm -rf builds/*

xhost:
	xhost +local:root
