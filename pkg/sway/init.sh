#!/bin/sh

udevd -d
udevadm trigger
su - user -c "XDG_RUNTIME_DIR=/tmp seatd-launch sway"

sleep 10000000
