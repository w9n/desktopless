FROM wiin/alpine:latest as deps

RUN apk add --no-cache  \
	gcc \
	libc-dev \
	git \
	make \
	go

ENV GOPATH /go

RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache
#Run apk add --update git make build-base

#hack
RUN git clone https://github.com/w9n/linuxkit  linuxkit
RUN cd ./linuxkit/src/cmd/linuxkit && \
	go build  -o linuxkit && \
	cp linuxkit /go/bin

RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

#FROM frolvlad/alpine-glibc
FROM alpine:edge
COPY --from=deps /go/bin /usr/bin


RUN apk add --update \
	bash \
	docker \
	git \
	dnsmasq \
	qemu-img \
	qemu-system-x86_64 \
	terminus-font \
	&& rm -rf /var/cache/pkg

#RUN git clone https://github.com/w9n/linuxkit /pkgs/linuxkit
#RUN git clone https://github.com/linuxkit/kubernetes /pkgs/kubernetes
#RUN git clone https://github.com/w9n/desktopless /pkgs/desktopless

COPY ./init.sh /usr/bin
COPY ./network.sh /usr/bin
COPY ./config.yml /root/.moby/linuxkit/config.yml

WORKDIR /workdir

ENTRYPOINT ["init.sh"]
