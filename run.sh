#!/bin/bash

: ${BUILD_CONTAINER:=}
: ${DOCKER_REPO_PREFIX:=wiin}
: ${DOCKER_TAG:=latest}
: ${DEV:=true}
: ${REMOTE_VIEWER:=true}
: ${DOCKER_SOCKET:=}

: ${NETWORK_NAME:=deskopless}
: ${NETWORK_SUBNET:=10.10.10.1/24}
docker network create --subnet $NETWORK_SUBNET $NETWORK_NAME

: ${DESKTOPLESS_IP:=10.10.10.10}
: ${DESKTOPLESS_PORT:=5930}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#xhost +local:root

[ ! -z "$BUILD_CONTAINER" ] && {
    $DIR/build.sh
}

[ ! -z "$REMOTE_VIEWER" ] && {
    . ./dockerfiles/remote-viewer/run.sh \
    --host $DESKTOPLESS_IP \
    --port $DESKTOPLESS_PORT \
    --protocol spice

}&

. ./dockerfiles/desktopless/run.sh $@
