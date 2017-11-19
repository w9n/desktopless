#!/bin/sh
run=false
name=build

__ScriptVersion="0.1"
function usage ()
{
	echo "Usage :  $0 [options] [--]

    Options:
    -h|help       Display this message
    -v|version    Display script version
    -n|name       Name of build
	-r|run        Run build
	-s|skip       Skip build"
}   

while getopts ":n:srhv" opt
do
  case $opt in
	n|name     )  name=$OPTARG ;;
	r|run      )  run=true ;;
	s|skip     )  skip=true ;;
	h|help     )  usage; exit 0   ;;
	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;
	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

function build() {
	for var in "$@"
	do
		param="$param $var.yml"
	done
	
	moby build ${MOBY_PARAMTER} -format iso-bios -name $name $param 
}

[[ "$#" -eq 0 ]] && exit 0

#fix until virt-viewer is repaired
virt-manager

[[ ! skip = true ]] build

while [[ ! -f /var/run/libvirtd.pid ]]; do
	sleep 1000
done

[[ ${run} = true ]] && run_virt.sh $name

