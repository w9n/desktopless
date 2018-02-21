# desktopless

desktopless, a proof of concept to build immutable and composable desktops. Based on [moby](https://github.com/moby/tool), [linuxkit](https://github.com/linuxkit/linuxkit/) and highly inspired by the [linuxkit kubernetes project](https://github.com/linuxkit/kubernetes).

## Requirments

Only Docker is required

invoke the build script from within the desktopless container to build all other container with `linuxkit` cli.

**NOTE:** The build an run process currently use a [custom linuxkit](https://github.com/w9n/linuxkit) cli inside.

## Run
`run.sh`

assembles and/or runs a named desktop in a container.

`dd if=./builds/some.iso of=/dev/sdxX`

Create a bootable usb-stick

## Examples

`./run.sh -b -r yml/kernel-lkt.yml yml/base.yml X-qxl.yml`

minimal X setup for virtualization on qemu/spice

`./run.sh -b yml/kernel-fedora.yml yml/base.yml X-intel.yml`

minimal X setup for desktops/igpus

`.. yml/i3`

i3, a simple tilling window manager 

`.. yml/state.yml`

if empty format the first attached disk, afterwords mount it.

`.. yml/docker.yml`

add a docker daemon

`.. yml/docker-skopeo-image-cache.yml`

preload the docker daemon with some images defined in `pkg/docker-skopeo-image-cache/image.list`

# Happy Hacking!
