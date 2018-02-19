#!/bin/sh
repo=wiin

echo "build alpine base"
docker build -t $repo/alpine ./tools/alpine
echo "build desktopless"
docker build -t $repo/desktopless ./dockerfiles/desktopless 
echo "build remote-viewer"
docker build -t $repo/remote-viewer ./dockerfiles/remote-viewer 
echo "build i3"
linuxkit pkg build -disable-content-trust ./pkg/i3
echo "build linux-firmware"
linuxkit pkg build -disable-content-trust ./pkg/linux-firmware
echo "build x-intel"
linuxkit pkg build -disable-content-trust ./pkg/X-intel
echo " build x-qxl"
linuxkit pkg build -disable-content-trust ./pkg/X-qxl
echo "docker-skopeo"
linuxkit pkg build -disable-content-trust -network ./pkg/docker-skopeo-image-cache
