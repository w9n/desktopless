FROM alpine:latest 

RUN apk add --no-cache  \
	dbus \
	font-noto \
	virt-viewer

COPY ./init.sh /usr/local/bin/

ENTRYPOINT ["init.sh"]
