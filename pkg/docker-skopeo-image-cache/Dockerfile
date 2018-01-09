FROM alpine:edge AS mirror

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /out/etc/apk/repositories
RUN apk update
RUN apk add --initdb --no-cache --root /out \
       alpine-baselayout \
	   device-mapper \
       busybox \
	   ostree

# Remove apk residuals
RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM golang:1.9-alpine AS skopeo

RUN apk add --no-cache git bash || apk update && apk upgrade
RUN apk add --no-cache make gcc python2 perl || apk update && apk upgrade

RUN apk add --no-cache \
    musl-dev \
    btrfs-progs-dev \
    lvm2-dev \
    gpgme-dev \
    glib-dev || apk update && apk upgrade

RUN apk add --no-cache -X http://nl.alpinelinux.org/alpine/edge/testing ostree-dev

WORKDIR /go/src/github.com/projectatomic/skopeo

RUN git clone https://github.com/projectatomic/skopeo ./

RUN make binary-local

RUN cp ./skopeo /skopeo

FROM scratch AS fetcher

COPY --from=mirror /out/ /

WORKDIR /workdir
COPY --from=skopeo /skopeo /usr/bin/skopeo

COPY image.list image.list
COPY download-images.sh download-images.sh
RUN ./download-images.sh

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=skopeo /skopeo /usr/bin/skopeo
COPY --from=docker:17.10.0-ce /usr/local/bin/docker /usr/local/bin/docker
COPY --from=mirror /out/ /
COPY --from=fetcher /images /images
COPY import-images.sh /usr/bin/import-images.sh
CMD [ "import-images.sh" ]

