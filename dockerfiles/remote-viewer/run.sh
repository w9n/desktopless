#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
: ${DISPLAY=":0"}

remote_viewer(){
    : ${DOCKER_REPO_PREFIX:=desktopless}
    : ${DOCKER_TAG:=latest}

    [ ! -z "$NETWORK_NAME" ] && NET=" \
        --net $NETWORK_NAME"

    [ ! -z "$DEV" ] && DEV_PARAM=" \
        -v $DIR/init.sh:/usr/local/bin/init.sh"

    docker run \
        --rm \
        -d \
        $NET \
        -e DISPLAY=unix$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        ${DOCKER_REPO_PREFIX}/remote-viewer:${DOCKER_TAG} \
        $@
}
echo $@

remote_viewer $@
