#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_PATH/load-environment

#nohup is used for a quick and dirty demonization here
if pgrep gzserver &>/dev/null ; then
   nohup $PREFIX/bin/gzserver --verbose 0<&- &>/tmp/gzserver.log &
fi
nohup $HOME/osrf-gzweb-b027171f5aa1/start_gzweb.sh 0<&- &>/tmp/gzweb.log &

