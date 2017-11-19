#!/bin/bash

: ${DOCKER_REPO_PREFIX:=wiin}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

		## not tested yet
		#--link pulseaudio:pulseaudio \
		#-e PULSE_SERVER=pulseaudio \
		#--group-add audio \
	docker run -d \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /${DIR}:/workdir \
		-e "DISPLAY=unix${DISPLAY}" \
		--name desktopless \
		--privileged \
		${DOCKER_REPO_PREFIX}/desktopless \
		$@
