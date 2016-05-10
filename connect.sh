#!/bin/bash

set -e

CONTAINER_ID="$( docker ps -a | grep gazebo:7.1 | awk '{ print $1; }' )"
CONTAINER_IP="$( docker inspect ${CONTAINER_ID} | grep '\"IPAddress\"' | awk '{ print $2; }' | head -n 1 | tr -d '",' )"
EXE_CMD='/usr/bin/gazebo'

echo ">>> Gazebo running in container at ${CONTAINER_IP} <<<"
ssh -YC -i ./ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null docker@${CONTAINER_IP} "${EXE_CMD}"
