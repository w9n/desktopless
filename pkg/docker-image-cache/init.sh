#!/bin/sh
for image in /images/*.tar ; do 
    (docker import $image $(grep $(echo $image | sed -e 's/.*\/\(.*\)@.*/\1/') /images.lst  | sed -e 's/:.*//')) && rm -f $image  
done
