#!/bin/sh

while [ ! -S /var/run/docker.sock ] ; do
   sleep 1
done
path=/images/
#deepest dirs
for image_dir in $(find $path -type d -links 2)
do 
	#image_name=$(echo $image_dir | rev | cut -d/ -f1 | rev)
    image_name=${image_dir#$path}
	echo import $image_name

	skopeo --insecure-policy copy dir:$image_dir docker-daemon:$image_name  && rm -rf $image_dir ; 
done
