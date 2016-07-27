#!/bin/bash

SCRIPT_PATH=$(pwd)
PREFIX=$HOME/local
mkdir -p $PREFIX
TEMP=$HOME/tmp
mkdir -p $TEMP

mkdir -p $PREFIX/include
mkdir -p $PREFIX/lib

NUM_OF_PROCESSORS=$(grep -c ^processor /proc/cpuinfo)

export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig:$PKG_CONFIG_PATH
export LIBRARY_PATH=$PREFIX/lib:$PREFIX/lib64
export LD_LIBRARY_PATH=$LIBRARY_PATH
export C_INCLUDE_PATH=$PREFIX/include:$CPLUS_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=$C_INCLUDE_PATH

#base dependiencies
module load CMake/3.4.1-GCC-4.9.2
module load Autotools/20150215-GCC-4.9.3-2.25
module load intel-tbb-oss/intel64/44_20160526oss

#ignition math
#cd $TEMP
#wget https://bitbucket.org/ignitionrobotics/ign-math/get/ignition-math2_2.5.0.tar.bz2
#tar xvf ignition-math2_2.5.0.tar.bz2
#cd ignitionrobotics-ign-math-6c0e329b4808 && mkdir -p build && cd build
#cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX
#make -j$NUM_OF_PROCESSORS
#make install

#tiny xml
#cd $TEMP
#wget https://sourceforge.net/projects/tinyxml/files/tinyxml/2.6.2/tinyxml_2_6_2.tar.gz/download -O tinyxml_2_6_2.tar.gz
#tar xvf tinyxml_2_6_2.tar.gz
#cd tinyxml
#patch < $SCRIPT_PATH/Makefile.patch
#patch < $SCRIPT_PATH/tinyxml.h.patch
#make -j$NUM_OF_PROCESSORS #CFLAGS="-DTIXML_USE_STL"
#cp tinyxml.h $PREFIX/include
#ar crf libtinyxml.a $(ls *.o | grep -v xmltest)
#cp libtinyxml.a $PREFIX/lib
#gcc -shared -o libtinyxml.so $(ls *.o | grep -v xmltest) 
#cp libtinyxml.so $PREFIX/lib


#SD format
#cd $TEMP
#wget https://bitbucket.org/osrf/sdformat/get/sdformat4_4.1.1.tar.bz2
#tar xvf sdformat4_4.1.1.tar.bz2
#cd osrf-sdformat-10551a6e8a2c && mkdir -p build && cd build
#cmake -DCMAKE_INSTALL_PREFIX=$PREFIX ..
#make -j$NUM_OF_PROCESSORS #CFLAGS="-DTIXML_USE_STL"
#make install

#protobuf
#cd $TEMP
#wget https://github.com/google/protobuf/archive/v3.0.0-beta-4.tar.gz
#tar xvf v3.0.0-beta-4.tar.gz
#cd protobuf-3.0.0-beta-4
#./autogen.sh
#./configure --prefix=$PREFIX
#make -j$NUM_OF_PROCESSORS 
#make install

#freeimage
#cd $TEMP
#wget https://sourceforge.net/projects/freeimage/files/Source%20Distribution/3.17.0/FreeImage3170.zip
#unzip FreeImage3170.zip 
#cd FreeImage
#cp Dist/lib* $PREFIX/lib 
#cp Dist/FreeImage.h $PREFIX/include

#openGL
OPENGL_INCLUDE_DIR=/cm/shared/apps/cuda-8.0/extras/CUPTI/include

#libcurl
export PKG_CONFIG_PATH=/cm/local/apps/curl/lib/pkgconfig:$PKG_CONFIG_PATH

##libtar
#cd $TEMP
#wget --no-check-certificate https://repo.or.cz/libtar.git/snapshot/0907a9034eaf2a57e8e4a9439f793f3f05d446cd.tar.gz -O libtar-1.2.2.tar.gz
#tar xvf libtar-1.2.2.tar.gz
#cd libtar-0907a90
#autoreconf --force --install
#./configure --prefix=$PREFIX \
#            --disable-static \
#            --disable-encap \
#            --disable-epkg-install
#make -j$NUM_OF_PROCESSORS
#make install

##xorg util-macros
#cd $TEMP
#wget https://www.x.org/releases/individual/util/util-macros-1.19.0.tar.gz
#tar xvf util-macros-1.19.0.tar.gz
#cd util-macros-1.19.0
#export ACLOCAL="aclocal -I ${PREFIX}/share/aclocal"
#./configure --prefix=$PREFIX
#make -j$NUM_OF_PROCESSORS
#make install

#xorg xproto
#cd $TEMP
#wget https://www.x.org/releases/individual/proto/xproto-7.0.29.tar.gz
#tar xvf xproto-7.0.29.tar.gz
#cd xproto-7.0.29
#./configure --prefix=$PREFIX
#make
#make install

#xorg xextproto
#cd $temp
#wget https://www.x.org/releases/individual/proto/xextproto-7.3.0.tar.gz
#tar xvf xextproto-7.3.0.tar.gz
#cd xextproto-7.3.0
#./configure --prefix=$PREFIX
#make
#make install

##xorg inputproto 
#cd $temp
#wget https://www.x.org/releases/individual/proto/inputproto-2.3.tar.gz
#tar xvf inputproto-2.3.tar.gz
#cd inputproto-2.3
#./configure --prefix=$PREFIX
#make
#make install

##xorg inputproto 
#cd $temp
#wget https://www.x.org/releases/individual/proto/kbproto-1.0.7.tar.gz
#tar xvf kbproto-1.0.7.tar.gz
#cd kbproto-1.0.7
#./configure --prefix=$PREFIX
#make
#make install

##xorg xtrans
#cd $TEMP
#wget https://www.x.org/releases/individual/lib/xtrans-1.3.5.tar.gz
#tar xvf xtrans-1.3.5.tar.gz 
#cd xtrans-1.3.5
#./configure --prefix=$PREFIX
#make
#make install

##xorg xcb-proto
#wget https://xcb.freedesktop.org/dist/xcb-proto-1.12.tar.gz
#tar xvf xcb-proto-1.12.tar.gz
#cd xcb-proto-1.12
#./configure --prefix=$PREFIX
#make -j$NUM_OF_PROCESSORS
#make install

##xau
#cd $TEMP
#wget https://www.x.org/releases/individual/lib/libXau-1.0.8.tar.gz
#tar xvf libXau-1.0.8.tar.gz
#cd libXau-1.0.8
#./configure --prefix=$PREFIX
#make
#make install

##libpthread stubs
#cd $TEMP
#wget https://xcb.freedesktop.org/dist/libpthread-stubs-0.3.tar.gz
#tar xvf libpthread-stubs-0.3.tar.gz
#cd libpthread-stubs-0.3
#./configure --prefix=$PREFIX
#make install

##xorg libxcb
#cd $TEMP
#wget https://xcb.freedesktop.org/dist/libxcb-1.12.tar.gz
#tar xvf libxcb-1.12.tar.gz
#cd libxcb-1.12
#./configure --prefix=$PREFIX --enable-xinput --enable-xkb --disable-static
#make -j$NUM_OF_PROCESSORS
#make install

##xorg libX11
#cd $TEMP
#wget https://www.x.org/releases/X11R7.7/src/lib/libX11-1.5.0.tar.gz
#tar xvf libX11-1.5.0.tar.gz
#cd libX11-1.5.0
#./configure --prefix=$PREFIX
#make -j$NUM_OF_PROCESSORS
#make install

##xorg libpixman
#cd $TEMP
#wget https://www.x.org/releases/individual/lib/pixman-0.34.0.tar.gz
#tar xvf pixman-0.34.0.tar.gz
#cd pixman-0.34.0
#./configure --prefix=$PREFIX
#make -j$NUM_OF_PROCESSORS
#make install

##xorg libxext
#cd $TEMP
#wget https://www.x.org/releases/individual/lib/libXext-1.2.0.tar.gz
#tar xvf libXext-1.2.0.tar.gz
#cd libXext-1.2.0
#./configure --prefix=$PREFIX
#make -j$NUM_OF_PROCESSORS
#make install

##libpng
#cd $TEMP
#wget https://sourceforge.net/projects/libpng/files/libpng16/1.6.23/libpng-1.6.23.tar.gz
#tar xvf libpng-1.6.23.tar.gz
#cd libpng-1.6.23
#./configure --prefix=$PREFIX
#make -j$NUM_OF_PROCESSORS
#make install

##cairo
#cd $TEMP
#wget https://www.cairographics.org/releases/cairo-1.14.6.tar.xz
#tar xvf cairo-1.14.6.tar.xz
#cd cairo-1.14.6
#./configure --prefix=$PREFIX
#make -j$NUM_OF_PROCESSORS
#make install

##freetype (without harfbuz)
#cd $TEMP
#wget http://download.savannah.gnu.org/releases/freetype/freetype-2.6.tar.gz
#tar xvf freetype-2.6.tar.gz
#cd freetype-2.6
#./configure --prefix=$PREFIX --without-harfbuzz
#make -j$NUM_OF_PROCESSORS
#make install
#
##harfbuzz
#cd $TEMP
#wget https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.3.0.tar.bz2
#tar xvf harfbuzz-1.3.0.tar.bz2
#cd harfbuzz-1.3.0
#./configure --prefix=$PREFIX
#make -j$NUM_OF_PROCESSORS
#make install
#
##freetype (now with harfbux)
#cd $TEMP
#cd freetype-2.6
#make distclean
#./configure --prefix=$PREFIX
#make -j$NUM_OF_PROCESSORS
#make install

##fontconfig
#cd $TEMP
#wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.0.tar.gz
#tar xvf fontconfig-2.12.0.tar.gz
#cd fontconfig-2.12.0
#./configure --prefix=$PREFIX --enable-libxml2
#make -j$NUM_OF_PROCESSORS
#make install

##libffi
#wget ftp://sourceware.org/pub/libffi/libffi-3.2.tar.gz
#tar xvf libffi-3.2.tar.gz
#cd libffi-3.2
#./configure --prefix=$PREFIX
#make -j$NUM_OF_PROCESSORS
#make install

##glibc
#wget http://ftp.gnome.org/pub/GNOME/sources/glib/2.49/glib-2.49.4.tar.xz
#tar xvf glib-2.49.4.tar.xz
#cd glib-2.49.4
#./configure --prefix=$PREFIX
#make -j$NUM_OF_PROCESSORS
#make install

#pango
cd $TEMP
wget http://ftp.gnome.org/pub/GNOME/sources/pango/1.40/pango-1.40.1.tar.xz
tar xvf pango-1.40.1.tar.xz
cd pango-1.40.1
./configure --prefix=$PREFIX
make -j$NUM_OF_PROCESSORS
make install

#gtk+-3.0
cd $TEMP
wget http://ftp.gnome.org/pub/gnome/sources/gtk+/3.20/gtk+-3.20.6.tar.xz
tar xvf gtk+-3.20.6.tar.xz
cd gtk+-3.20.6
./configure --prefix=$PREFIX
make -j$NUM_OF_PROCESSORS
make install

#gtk-3.0


#sm
wget http://www.joachim-breitner.de/archive/screen-message/screen-message-0.24.tar.gz
tar xvf screen-message-0.24.tar.gz
cd screen-message-0.24
./configure --prefix=$PREFIX
make
make install

#ice

#xorg xt
cd $TEMP
wget https://www.x.org/releases/individual/lib/libXt-1.1.5.tar.gz
tar xvf libXt-1.1.5.tar.gz
cd libXt-1.1.5
./configure --prefix=$PREFIX
make -j$NUM_OF_PROCESSORS
make install 

#xorg xaw
cd $TEMP
wget https://www.x.org/releases/individual/lib/libXaw-1.0.13.tar.gz
tar xvf libXaw-1.0.13.tar.gz
cd libXaw-1.0.13
./configure --prefix=$PREFIX
make -j$NUM_OF_PROCESSORS
make install

#ogre
cd $TEMP
#wget https://bitbucket.org/sinbad/ogre/get/v1-9-0.tar.bz2 -o ogre-v1-9-0.tar.bz2
##https://bitbucket.org/sinbad/ogre/commits/a24ac4afbbb9dc5ff49a61634af50da11ba8fb97/raw/
##https://bitbucket.org/sinbad/ogre/commits/d84bce645d3dd439188d3d29d8da51c51765a085/raw/
#tar xvf ogre-v1-9-0.tar.bz2 
cd sinbad-ogre-dd30349ea667
[[ -d build ]] && rm -rf build
mkdir build && cd build
cmake .. \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DOGRE_INSTALL_SAMPLES=FALSE \
    -DOGRE_INSTALL_DOCS=FALSE \
    -DOGRE_INSTALL_SAMPLES_SOURCE=FALSE \
    -DCMAKE_BUILD_TYPE=Release
make
#make OgreDoc

#gazebo
cd $TEMP
#wget https://bitbucket.org/osrf/gazebo/get/gazebo7_7.3.1.tar.bz2
#tar xvf gazebo7_7.3.1.tar.bz2
#cd osrf-gazebo-9bc8cb494795 && mkdir -p build && cd build
#cmake -DOPENGL_INCLUDE_DIR=$OPENGL_INCLUDE_DIR -DCMAKE_INSTALL_PREFIX=$PREFIX ..



