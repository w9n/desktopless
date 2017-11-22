# desktopless
This is a proof of concept to build an immutable and composable desktop based on [moby](https://github.com/moby/tool), [linuxkit](https://github.com/linuxkit/linuxkit/) and highly inspired by the [linuxkit kubernetes project](https://github.com/linuxkit/kubernetes).

**NOTE:** This is far from usable in the real world.
## Requirments
All you need is Docker and an unprotected X socket to get started. You might have to `xhost +local:root` on your host to allow access for the container.

## Run
`make` starts a container that builds and imports the system into libvirt to easily adjust the vm settings. It automatically starts virt-manager. The build progess is visible by `docker logs desktopless`.

## make i3
#### yml/base.yml
The base system containing the most necessary containers to start other containers and do dhcp configuration for internet connectivity.
#### yml/xserver.yml
The X server provides the socket that can be consumed by any window manager and application.
#### yml/i3.yml
A very nice and basic window manager.
## make i3-docker (might get replaced with something based on containerd namespaces)
#### yml/docker.yml
This should be the main source of applications and pass the X Socket into containers started by the user. It should be the only stateful container (not implemented yet).
## make i3-docker-cached
#### yml/docker-image-cache.yml
load offline images into docker on boot time. The available images are defined in `pkg/docker-image-cache/image.list` on its container build time.
