FROM alpine:edge AS mirror

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --initdb --no-cache --root /out \
	alpine-baselayout \
	sway \
	eudev \
	ttf-dejavu \
	seatd-launch \
	libseat \
	xf86-video-intel \
	xf86-input-libinput \
	mesa \
	xwayland \
	mesa-dri-swrast \
	foot \
	xf86-video-qxl

RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM scratch
WORKDIR /
COPY --from=mirror /out/ /
RUN adduser -D user
RUN adduser user input
RUN adduser user video
RUN adduser user root
COPY ./init.sh /usr/bin/
ENV XDG_RUNTIME_DIR /tmp

CMD ["/usr/bin/init.sh"]
