FROM alpine:edge
ENTRYPOINT []
CMD []
WORKDIR /

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories

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

LABEL org.mobyproject.config='{"binds": ["/tmp:/tmp:rshared,rbind", "/run:/run", "/etc/resolv.conf:/etc/resolv.conf", "/etc:/hostroot/etc", "/usr/bin/ctr:/usr/bin/ctr", "/usr/bin/runc:/usr/bin/runc", "/containers:/containers","/var/log:/var/log" ], "capabilities": ["all"] }'
