FROM golang:alpine as deps

Run apk add --update git

RUN go get -u github.com/linuxkit/linuxkit/src/cmd/linuxkit
RUN go get -u github.com/moby/tool/cmd/moby

FROM alpine:edge

COPY --from=deps /go/bin /usr/bin

RUN apk add --update \
	dbus \
	docker \
	polkit \
	qemu-img \
	qemu-system-x86_64 \
	libvirt-daemon \
	libvirt \
	virt-manager \
	virt-install \
	&& rm -rf /var/cache/pkg

COPY ./scripts /usr/bin

WORKDIR /workdir

ENTRYPOINT ["init.sh"]
CMD [""]
