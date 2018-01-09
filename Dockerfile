FROM golang:alpine as deps

Run apk add --update git make build-base

RUN go get -u github.com/linuxkit/linuxkit/src/cmd/linuxkit
RUN go get -u github.com/moby/tool/cmd/moby

FROM alpine:edge

COPY --from=deps /go/bin /usr/bin

RUN apk add --update \
	dbus \
	docker \
	git \
	polkit \
	qemu-img \
	qemu-system-x86_64 \
	libvirt-daemon \
	libvirt \
	virt-manager \
	virt-install \
	&& rm -rf /var/cache/pkg

RUN git clone https://github.com/linuxkit/linuxkit /pkgs/linuxkit
RUN git clone https://github.com/linuxkit/kubernetes /pkgs/kubernetes
RUN git clone https://github.com/w9n/desktopless /pkgs/desktopless

COPY ./scripts /usr/bin
COPY ./config.yml /root/.moby/linuxkit/config.yml


WORKDIR /workdir

CMD ["sh"]
