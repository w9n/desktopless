FROM alpine:edge AS mirror
RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk update
RUN apk add --initdb --no-cache --root /out \
	alpine-baselayout \
    xorg-server \
	xf86-input-mouse \
	xf86-input-keyboard \
	xf86-input-libinput \
	udev \
	xterm \
	xf86-video-qxl

# Remove apk residuals
RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=mirror /out/ /
COPY xorg.conf /etc/X11/xorg.conf
CMD ["sh", "-c", "udevd -d && udevadm trigger && X || sleep 100000"]
ENV DISPLAY :0.0

LABEL org.mobyproject.config=' \
{ \
  "binds": [ \
    "/tmp:/tmp:rshared,rbind", \
    "/dev:/dev:rshared,rbind", \
    "/sys:/sys:rshared,rbind" \
  ], \
  "capabilities": [ \
    "all" \
  ] \
} \
'
