FROM wiin/alpine:a467a87bef10f37055d59f4c453208d16b3526a1 AS build
ENTRYPOINT []
CMD []
WORKDIR /
RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --no-cache --initdb -p /out \
	i3wm \
	git \
	xorg-server \
	xterm 

RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM wiin/alpine:a467a87bef10f37055d59f4c453208d16b3526a1 AS docker
RUN apk add --no-cache \
	docker

FROM Scratch
COPY --from=build /out /
#hack
COPY --from=docker /usr/bin/docker /usr/bin/docker

#hack
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN apk add  --no-cache \
	i3status \
	xkeyboard-config 


CMD ["sh", "-c", "while [ ! -S /tmp/.X11-unix/X0 ]; do sleep 1; done; i3 || sleep 1000000000000"]
ENV DISPLAY :0.0
