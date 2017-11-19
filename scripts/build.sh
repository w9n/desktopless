#!/bin/sh

[[ "$#" -eq 0 ]] && exit 0

[[ $1 -eq "-d" ]] && cd $2 && shift 2;

for var in "$@"
do
	param="$param $var.yml"
done
#fix until virt-viewer is repaired
virt-manager

moby build ${MOBY_PARAMTER} -format iso-bios $param

while [[ ! -f /var/run/libvirtd.pid ]]; do
	sleep 1000
done

run_virt.sh $1

