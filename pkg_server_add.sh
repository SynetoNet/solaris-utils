#!/usr/bin/bash

usage() {
    echo "Usage: $0 [ -i <instance_name> ] [ -p <port> ] [ -d <pkg_repo_dir> ] " 2>&1
    exit 1
}

function generate_id {
  echo $(cat /dev/urandom | LC_CTYPE=C tr -dc "a-zA-Z0-9" | head -c 6)
}

while getopts "i:p:d:" arg; do
    case $arg in
	i)
	    INSTANCE_NAME=${OPTARG}
            ;;
        p)
            PORT=$OPTARG
            ;;
	d)
	    DIR=$OPTARG
	    ;;
	*)
	    usage
	    ;;
    esac
done

shift $(($OPTIND - 1))

if [ -z $INSTANCE_NAME ] || [ -z $PORT ] || [ -z $DIR ]; then
    usage
fi

TEMP_FILE=/tmp/$(generate_id)

cat << EOF > $TEMP_FILE  
select pkg/server
add ${INSTANCE_NAME}
select ${INSTANCE_NAME}
addpg pkg application
addpg general framework
setprop general/enabled = boolean: false
setprop pkg/mirror = boolean: false
setprop pkg/inst_root = astring: ${DIR}
setprop pkg/port = count: ${PORT}
setprop pkg/threads = count: 50
exit
EOF
echo "Creating service ..."
svccfg -f $TEMP_FILE
echo "Done."
fmri=pkg/server:$INSTANCE_NAME
echo "Enabling ${fmri} ..."
svcadm refresh $fmri
svcadm enable $fmri
echo "Done."
rm $TEMP_FILE 2>/dev/null
exit 0
