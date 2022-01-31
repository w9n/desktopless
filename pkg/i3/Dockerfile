FROM desktopless/alpine:0987b34b7cd37a623d56c8b2e977a19974408136-amd64 as build
ENTRYPOINT []
CMD []
WORKDIR /
RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --no-cache --initdb -p /out \
	alpine-baselayout \
	apk-tools \
	i3wm \
	git \
	libltdl \
	xorg-server \
	xkeyboard-config \
	i3status \
	xterm 

RUN mv /out/etc/apk/repositories.upstream /out/etc/apk/repositories

FROM desktopless/alpine:0987b34b7cd37a623d56c8b2e977a19974408136-amd64 as docker
RUN apk add --no-cache \
	docker

FROM scratch

COPY --from=build /out /
COPY --from=docker /usr/bin/docker /usr/bin/docker

CMD ["sh", "-c", "while [ ! -S /tmp/.X11-unix/X0 ]; do sleep 1; done; i3 || sleep 1000000000000"]
ENV DISPLAY :0.0
