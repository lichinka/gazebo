#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_PATH/load-environment

$PREFIX/bin/gazebo --verbose 2>&1 > /tmp/gazebo.log
