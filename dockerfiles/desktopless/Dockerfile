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
RUN mkdir -p /go/src/github.com/w9n/linuxkit
WORKDIR /go/src/github.com/w9n/linuxkit
RUN git clone https://github.com/w9n/linuxkit ./
RUN find ./ -type f -print0 | xargs -0 sed -i 's#github.com/linuxkit/linuxkit#github.com/w9n/linuxkit#g'
RUN make local-build
RUN cp bin/* /go/bin/

RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

#FROM frolvlad/alpine-glibc
FROM alpine:edge
COPY --from=deps /go/bin /usr/bin


RUN apk add --update \
	docker \
	git \
	qemu-img \
	qemu-system-x86_64 \
	terminus-font \
	&& rm -rf /var/cache/pkg

RUN git clone https://github.com/w9n/linuxkit /pkgs/linuxkit
RUN git clone https://github.com/linuxkit/kubernetes /pkgs/kubernetes
RUN git clone https://github.com/w9n/desktopless /pkgs/desktopless

COPY ./init.sh /usr/bin
COPY ./config.yml /root/.moby/linuxkit/config.yml

WORKDIR /workdir

#COPY hack/linuxkit /usr/bin/linuxkit

ENTRYPOINT ["init.sh"]
CMD ["sh"]
