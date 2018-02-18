FROM wiin/alpine:latest AS mirror

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk update
RUN apk add --initdb --no-cache --root /out \
       alpine-baselayout \
       ostree \
       device-mapper \
       libselinux \
       busybox 

# Remove apk residuals
RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM wiin/alpine:latest AS skopeo

RUN apk add --no-cache \
    bash \
    btrfs-progs-dev \
    docker \
    gcc \
    git \
    go \
    glib-dev \
    gpgme-dev \
    libselinux-dev \
    lvm2-dev \
    make \
    musl-dev \
    ostree-dev \
    perl \
    python2


ENV GOPATH /go
WORKDIR /go/src/github.com/projectatomic/skopeo
COPY skopeo ./
RUN make binary-local
RUN cp ./skopeo /usr/bin/skopeo


FROM scratch AS fetcher

COPY --from=mirror /out/ /

WORKDIR /workdir
COPY --from=skopeo /usr/bin/skopeo /usr/bin/skopeo

COPY dl dl


FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=skopeo /usr/bin/skopeo /usr/bin/skopeo
COPY --from=skopeo /usr/bin/docker /usr/bin/docker
COPY --from=mirror /out/ /
COPY --from=fetcher /workdir/dl /images
COPY import-images.sh /usr/bin/import-images.sh
CMD [ "import-images.sh" ]
