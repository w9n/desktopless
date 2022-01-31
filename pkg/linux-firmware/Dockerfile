FROM desktopless/alpine:0987b34b7cd37a623d56c8b2e977a19974408136-amd64 AS mirror

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --initdb --no-cache --root /out \
	linux-firmware

RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=mirror /out/ /
