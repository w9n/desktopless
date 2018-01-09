#!/bin/sh

mkdir images
for image in $(cat image.list)
do
	echo $image
	mkdir -p /images/$image
	skopeo --insecure-policy copy docker://$image dir:/images/$image
done

