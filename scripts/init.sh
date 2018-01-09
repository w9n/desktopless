#!/bin/sh

name=desktopless
libvirt=false
build=false
moby_configs=

while [ "$#" -gt 0 ]; do
        case $1 in
            -n|--name)
                name=$2
                shift 2
                ;;
            -b|--build)
                build=true
                shift
                ;;
            -l|--libvirt)
                libvirt=true
                shift
                ;;
            *)
		        moby_configs="$moby_configs $1"
                shift
                ;;
        esac
done

virt()
 {
    /usr/bin/dbus-uuidgen --ensure=/etc/machine-id
    [ ! -e /var/run/dbus ] && mkdir /var/run/dbus
    dbus-daemon --system &
    virtlogd --daemon &
    libvirtd &
    virt-manager &
 }

 virtinstall(){
    virt-install \
    	--name=$name \
    	--memory=2000 \
    	--disk path=builds/$name.img,size=20 \
    	-c=builds/$name.iso \
    	--network network=default \
    	--input=tablet \
    	--video qxl &
 }

[ $build == "true" ] && (linuxkit bake $moby_configs | linuxkit build -disable-content-trust -format iso-bios -name builds/$name - && \
 [ $libvirt == "true" ] && virtinstall) || [ $libvirt == "true" ] && virtinstall &

[ $libvirt == "true" ] && virt &

sh
