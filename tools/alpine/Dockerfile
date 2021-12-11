FROM alpine:edge AS mirror

# update base image
RUN apk update && apk upgrade -a

COPY packages* /tmp/

run mkdir -p /mirror/$(uname -m)

# cuz its flagged
# mirror packages
run cat /tmp/packages.$(uname -m) >> /tmp/packages && \
    apk fetch --recursive -o /mirror/$(uname -m) $(apk info; cat /tmp/packages)

RUN apk fetch --recursive -o /mirror/$(uname -m) -X http://dl-cdn.alpinelinux.org/alpine/v3.7/main --no-cache $(apk info;echo dbus)
#test packages
RUN apk fetch --recursive -o /mirror/$(uname -m) -X http://dl-cdn.alpinelinux.org/alpine/edge/testing --no-cache $(apk info; cat /tmp/packages.testing)

# install abuild for signing
RUN apk add --no-cache sudo abuild

# install a new key into /etc/apk/keys
RUN abuild-keygen -a -i -n

# index the new repo
RUN apk index --rewrite-arch $(uname -m) -o /mirror/$(uname -m)/APKINDEX.unsigned.tar.gz /mirror/$(uname -m)/*.apk

# sign the index
RUN cp /mirror/$(uname -m)/APKINDEX.unsigned.tar.gz /mirror/$(uname -m)/APKINDEX.tar.gz
RUN abuild-sign /mirror/$(uname -m)/APKINDEX.tar.gz

# set this as our repo but keep a copy of the upstream for downstream use
RUN mv /etc/apk/repositories /etc/apk/repositories.upstream && echo "/mirror" > /etc/apk/repositories && apk update

# add Go validation tools
COPY go-compile.sh /go/bin/
RUN apk add --no-cache git go musl-dev
ENV GOPATH=/go PATH=$PATH:/go/bin
RUN go get -u golang.org/x/lint
RUN go get -u github.com/gordonklaus/ineffassign
RUN go get -u github.com/LK4D4/vndr

# checkout and compile containerd
# Update `FROM` in `pkg/containerd/Dockerfile`, `pkg/init/Dockerfile` and
# `test/pkg/containerd/Dockerfile` when changing this.
ENV CONTAINERD_REPO=https://github.com/containerd/containerd.git
ENV CONTAINERD_COMMIT=v1.4.11
RUN mkdir -p $GOPATH/src/github.com/containerd && \
  cd $GOPATH/src/github.com/containerd && \
  git clone https://github.com/containerd/containerd.git && \
  cd $GOPATH/src/github.com/containerd/containerd && \
  git checkout $CONTAINERD_COMMIT
RUN apk add --no-cache btrfs-progs-dev gcc libc-dev linux-headers make
RUN cd $GOPATH/src/github.com/containerd/containerd && \
  GO111MODULE=off make binaries EXTRA_FLAGS="-buildmode pie" EXTRA_LDFLAGS='-extldflags "-fno-PIC -static"' BUILDTAGS="static_build no_devmapper"

# Copy Dockerfile so we can include it in the hash
COPY Dockerfile /Dockerfile
WORKDIR /
FROM alpine:edge

COPY --from=mirror /etc/apk/repositories /etc/apk/repositories
COPY --from=mirror /etc/apk/repositories.upstream /etc/apk/repositories.upstream
COPY --from=mirror /etc/apk/keys /etc/apk/keys/
COPY --from=mirror /mirror /mirror/
COPY --from=mirror /go/bin /go/bin/
COPY --from=mirror /Dockerfile /Dockerfile
COPY --from=mirror /go/src/github.com/containerd/containerd /go/src/github.com/containerd/containerd/

RUN apk update && apk upgrade -a

