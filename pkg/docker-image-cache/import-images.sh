#!/bin/sh

#deepest dirs
for image_dir in $(find /images/ -type d -links 2)
do 
	image_name=$(echo $image_dir | rev | cut -d/ -f1 | rev)
	echo import $image_name
	skopeo --insecure-policy copy dir:$image_dir docker-daemon:$image_name  && rm -rf $image_dir ; 
done
