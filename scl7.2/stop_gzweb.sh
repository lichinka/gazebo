#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_PATH/load-environment

$HOME/osrf-gzweb-b027171f5aa1/stop_gzweb.sh
killall gzserver

