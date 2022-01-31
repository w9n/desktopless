FROM desktopless/alpine:5861bd79a63d80cdc119194016f0c36969343388-amd64 AS mirror

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --initdb --no-cache --root /out \
	alpine-baselayout \
    	xorg-server \
	xf86-video-intel \
	xf86-input-libinput \
	udev \
	xterm \
	xf86-video-qxl

RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=mirror /out/ /
COPY xorg.conf /etc/X11/xorg.conf
CMD ["sh", "-c", "udevd -d && udevadm trigger && X || sleep 100000"]
ENV DISPLAY :0.0
