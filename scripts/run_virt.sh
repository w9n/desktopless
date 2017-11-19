#!/bin/sh

name=$1
echo ${name}
virt-install \
	--name=${name} \
	--memory=2000 \
	--disk path=${name}.img,size=20 \
	-c=${name}.iso \
	--network network=default \
	--input=tablet \
	--video qxl &


