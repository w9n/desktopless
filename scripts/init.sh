#!/bin/sh

build.sh $@ &
/usr/bin/dbus-uuidgen --ensure=/etc/machine-id

	# We need to test if /var/run/dbus exists, since script will fail if it does not
[ ! -e /var/run/dbus ] && mkdir /var/run/dbus
dbus-daemon --system &
virtlogd --daemon &
libvirtd 

