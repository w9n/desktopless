FROM alpine:edge AS skopeo

RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

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
WORKDIR /go/src/github.com/containers/skopeo
RUN git clone https://github.com/containers/skopeo ./
RUN make bin/skopeo
RUN cp ./bin/skopeo /usr/bin/skopeo

FROM alpine:edge
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=skopeo /usr/bin/skopeo /usr/bin/skopeo
COPY --from=skopeo /usr/bin/docker /usr/bin/docker

RUN apk add --no-cache \
       alpine-baselayout \
       ostree \
       device-mapper \
       libselinux \
       busybox 

COPY dl /images 
COPY import-images.sh /usr/bin/import-images.sh
CMD [ "import-images.sh" ]
