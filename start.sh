#!/bin/bash

set -e

XDISP=":$( echo ${DISPLAY} | cut -d':' -f2 )"
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.$$.xauth

#
# create a new magic cookie for the container to access host's X
#
xauth nlist ${XDISP} | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge - > /dev/null 2>&1

echo "Starting GAZEBO ..."
echo "- use 'connect.sh' to launch the GUI."
echo "- use 'docker stop gazebo' to shutdown the container."

docker run --rm=true                            \
            -it                                 \
            -e DISPLAY=${XDISP}                 \
            -e XAUTHORITY=${XAUTH}              \
            -v ${XSOCK}:${XSOCK}                \
            -v ${XAUTH}:${XAUTH}                \
            -v /dev/drm:/dev/drm                \
            -P                                  \
            --name=gazebo                       \
            gazebo:7.1
