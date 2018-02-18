#!/bin/sh

rm -r dl/*
for image in $(cat image.list)
do
	echo $image
	mkdir -p ./dl/$image

    skopeo --insecure-policy copy docker://$image dir:./dl/$image
done

