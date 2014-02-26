#!/usr/bin/bash
# The MIT License (MIT)
#
# Copyright (c) 2013, S.C. Syneto S.R.L.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 

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
