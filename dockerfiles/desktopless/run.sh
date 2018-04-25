#!/bin/sh

desktopless()
{
    : ${DOCKER_REPO_PREFIX:=wiin}
    : ${DOCKER_TAG:=latest}
    : ${DESKTOPLESS_IP:=}
    : ${DEV=}

    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    [ ! -z $DEV ] && DEV_PARAM=" \
        -v /$DIR/../..:/workdir \
        -v /$DIR/init.sh:/usr/bin/init.sh"

    [ ! -z $DESKTOPLESS_IP ] && IP=" \
        --ip $DESKTOPLESS_IP"
    
    [ ! -z $NETWORK_NAME ] && NET=" \
        --net $NETWORK_NAME"

    docker run \
        --name desktopless \
        --privileged \
        --rm \
        -it \
        $DEV_PARAM \
        $IP \
        $NET \
        -v /dev:/dev \
        -v /var/run/docker.sock:/var/run/docker.sock \
        ${DOCKER_REPO_PREFIX}/desktopless:${DOCKER_TAG} \
        $@   
}

desktopless $@
