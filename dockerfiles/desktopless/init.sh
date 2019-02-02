#!/bin/sh
: ${name=desktopless}
: ${run=false}
: ${build=false}
: ${moby_configs=}

usage="$(basename "$0") -- container to build and/or emulate desktopless 

where:
    -h|--help   show this help text
    -n|--name   name of the build
    -b|--build  if set build the desktop
    -r|--run    if set run the desktop"

err() {
    echo "missing argument" >&2
    echo "$usage" >&2
} 

echo $1
if [[ -z "$1" ]] ; then
    err
    exit 0
fi

while [ "$#" -gt 0 ]; do
        case $1 in
            -b|--build)
                build=true
                shift
                ;;
            -n|--name)
                name=$2
                shift 2
                ;;
            -r|--run)
                run=true
                shift
                ;;
            -s|--shell)
                sh
                exit 0
                ;;
            -h|--help)
                echo "$usage"
                exit 0
                ;;
            *)
		        moby_configs="$moby_configs $1"
                shift
                ;;
        esac
done

{
    [ $build == "true" ] && {
        echo "building $name..."
        echo $moby_configs
        linuxkit bake $moby_configs | linuxkit build -disable-content-trust -format iso-bios -name builds/$name -
    }

    [ $run == "true" ] && {
        echo "running $name..."
        linuxkit run qemu \
            -cpus 3 \
            -mem 4000 \
            -gui \
            -disk size=20G \
            -param "-vga qxl -spice port=5930,disable-ticketing -device virtio-serial-pci -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 -chardev spicevmc,id=spicechannel0,name=vdagent -usb -usbdevice tablet"\
            builds/$name.iso > linuxkit.log
    }
}&

sh
