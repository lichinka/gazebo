#!/bin/bash

set -e

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_PATH/load-environment
source $SCRIPT_PATH/install_with_configure_script

#nodejs
wget https://nodejs.org/dist/v0.10.46/node-v0.10.46.tar.gz
tar xvf node-v0.10.46.tar.gz
cd node-v0.10.46
./configure --prefix=$PREFIX 2>&1 | tee output-configure
make -j$NUM_OF_PROCESSORS 2>&1 | tee output-make
make install 2>&1 | tee output-make-install

install_with_configure_script http://www.digip.org/jansson/releases/jansson-2.7.tar.gz

#mercurial
cd $TEMP
wget https://www.mercurial-scm.org/release//mercurial-3.8.tar.gz
tar xvf mercurial-3.8.tar.gz
cd mercurial-3.8
python setup.py install --force --home=$PREFIX

#gzweb
gazebo_setup_script=$PREFIX/share/gazebo-7/setup.sh
if [ ! -f $gazebo_setup_script ]; then
   echo "error: could not find gazebo's setup.sh. Did you install gazebo?"
   exit 1
fi
source $gazebo_setup_script
cd $TEMP
wget https://bitbucket.org/osrf/gzweb/get/gzweb_1.3.0.tar.gz
cd $HOME
tar xvf $TEMP/gzweb_1.3.0.tar.gz
cd osrf-gzweb-b027171f5aa1
./deploy.sh -m 2>&1 | tee output-deploy

