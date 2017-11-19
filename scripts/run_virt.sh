#!/bin/sh

name=$1
echo ${name}
virt-install \
	--name=${name} \
	--memory=2000 \
	--disk path=builds/${name}.img,size=20 \
	-c=builds/${name}.iso \
	--network network=default \
	--input=tablet \
	--video qxl &


