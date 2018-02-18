#!/bin/sh

rm -r dl/*
for image in $(cat image.list)
do
	echo $image
	mkdir -p ./dl/$image
    #docker pull $image
    skopeo --insecure-policy copy docker-daemon:$image dir:./dl/$image
done

