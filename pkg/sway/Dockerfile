FROM wiin/alpine:latest as build
ENTRYPOINT []
CMD []
WORKDIR /
RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --no-cache --initdb -p /out \
	alpine-baselayout \
	apk-tools \
	sway \
	git \
	libltdl \
	xkeyboard-config \
	i3status \
	xterm 

RUN mv /out/etc/apk/repositories.upstream /out/etc/apk/repositories

FROM wiin/alpine:latest as docker
RUN apk add --no-cache \
	docker

FROM scratch

COPY --from=build /out /
COPY --from=docker /usr/bin/docker /usr/bin/docker

ENV XDG_RUNTIME_DIR=/run/wayland
CMD ["sh", "-c", "while [ ! -S /tmp/.X11-unix/X0 ]; do sleep 1; done; i3 || sleep 1000000000000"]
