FROM alpine:edge
ENTRYPOINT []
CMD []
WORKDIR /

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
COPY --from=docker:17.10.0-ce /usr/local/bin/docker /usr/local/bin/docker

RUN apk update
RUN apk add  \
    i3wm \
	i3status \
	git \
	xorg-server \
	xkeyboard-config \
	xterm 

CMD ["sh", "-c", "while [ ! -S /tmp/.X11-unix/X0 ]; do sleep 1; done; i3 || sleep 1000000000000"]
ENV DISPLAY :0.0
