#!/bin/sh
#should just simply passthrough to remote viewer and parse for port avail

: ${HOST:=10.10.10.10} 
: ${PORT:=5901}
: ${PROTOCOL:=spice}
usage="$(basename "$0") -- container to build and/or emulate desktopless 

where:
    -h|--help   show this help text
    --host      host to connect to
    --port      port to connect to
    --protocol  protocol to connect to"

while [ "$#" -gt 0 ]; do
        case $1 in
            --host)
                HOST=$2
                shift 2
                ;;
            --port)
                PORT=$2
                shift 2
                ;;
            --protocol)
                PROTOCOL=$2
                shift 2
                ;;
            -h|--help)
                echo "$usage"
                exit 0
                ;;
            sh)
                sh
                shift
                ;;
            *)
                echo "error $1!"
                shift
                exit 1
                ;;
        esac
done

[[ -z $HOST || -z $PORT ]] && {
    echo $HOST:$PORT is not valid!
    exit 1
}

/usr/bin/dbus-uuidgen --ensure=/etc/machine-id
[ ! -e /var/run/dbus ] && mkdir /var/run/dbus
dbus-daemon --system &

while ! nc -z $HOST $PORT; do
    sleep 1
done

echo "remote-viewer $PROTOCOL://$HOST:$PORT"
remote-viewer $PROTOCOL://$HOST:$PORT
