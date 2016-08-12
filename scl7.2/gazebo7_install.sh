#!/bin/bash

set -e

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_PATH/load-environment
source $SCRIPT_PATH/install_with_configure_script
mkdir -p $PREFIX
mkdir -p $TEMP
mkdir -p $PREFIX/include
mkdir -p $PREFIX/lib

#libcurl
empty_if_exists="$( pkg-config --exists libcurl || echo doesntexist )"
if [ -z "$empty_if_exists" ]; then
   echo "### LibCurl found"
else
   export PKG_CONFIG_PATH=/cm/local/apps/curl/lib/pkgconfig:$PKG_CONFIG_PATH
   export C_INCLUDE_PATH=/cm/local/apps/curl/include/:$C_INCLUDE_PATH
   export CPLUS_INCLUDE_PATH=/cm/local/apps/curl/include/:$CPLUS_INCLUDE_PATH
fi

#tinyxml
cd $TEMP
if [ ! -d "tinyxml" ]; then
   wget https://sourceforge.net/projects/tinyxml/files/tinyxml/2.6.2/tinyxml_2_6_2.tar.gz/download -O tinyxml_2_6_2.tar.gz
   tar xvf tinyxml_2_6_2.tar.gz
   cd tinyxml
   patch < $SCRIPT_PATH/patches/tinyxml/Makefile.patch
   patch < $SCRIPT_PATH/patches/tinyxml/tinyxml.h.patch
else
   cd tinyxml
fi
make -j$NUM_OF_PROCESSORS
cp tinyxml.h $PREFIX/include
ar crf libtinyxml.a $(ls *.o | grep -v xmltest)
cp libtinyxml.a $PREFIX/lib
gcc -shared -o libtinyxml.so $(ls *.o | grep -v xmltest) 
cp libtinyxml.so $PREFIX/lib

#tinyxml2
cd $TEMP
if [ ! -d "tinyxml2-3.0.0" ]; then
   wget https://github.com/leethomason/tinyxml2/archive/3.0.0.tar.gz -O tinyxml2-3.0.0.tar.gz
   tar xvf tinyxml2-3.0.0.tar.gz
fi
cd tinyxml2-3.0.0
mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX ..
make -j$NUM_OF_PROCESSORS 
make install

#ignition math
cd $TEMP
if [ ! -d "ignitionrobotics-ign-math-6c0e329b4808" ]; then
   wget https://bitbucket.org/ignitionrobotics/ign-math/get/ignition-math2_2.5.0.tar.bz2
   tar xvf ignition-math2_2.5.0.tar.bz2
fi
cd ignitionrobotics-ign-math-6c0e329b4808 && mkdir -p build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX
make -j$NUM_OF_PROCESSORS
make install

#SD format
cd $TEMP
if [ ! -d "osrf-sdformat-10551a6e8a2c" ]; then
   wget https://bitbucket.org/osrf/sdformat/get/sdformat4_4.1.1.tar.bz2
   tar xvf sdformat4_4.1.1.tar.bz2
fi
cd osrf-sdformat-10551a6e8a2c && mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX ..
make -j$NUM_OF_PROCESSORS
make install

#freeimage
cd $TEMP
if [ ! -d "FreeImage" ]; then
   wget https://sourceforge.net/projects/freeimage/files/Source%20Distribution/3.17.0/FreeImage3170.zip
   unzip FreeImage3170.zip
   cd FreeImage
   patch -p1 < ${SCRIPT_PATH}/patches/freeimage/dsp.patch
   cd ..
fi
cd FreeImage
CXX='g++ -Wno-narrowing' make -j$NUM_OF_PROCESSORS
cp Dist/lib* $PREFIX/lib 
cp Dist/FreeImage.h $PREFIX/include

##libtar
cd $TEMP
if [ ! -d "libtar-0907a90" ]; then
   wget --no-check-certificate https://repo.or.cz/libtar.git/snapshot/0907a9034eaf2a57e8e4a9439f793f3f05d446cd.tar.gz -O libtar-1.2.2.tar.gz
   tar xvf libtar-1.2.2.tar.gz
fi
cd libtar-0907a90
autoreconf --force --install
./configure --prefix=$PREFIX \
            --disable-static \
            --disable-encap \
            --disable-epkg-install
make -j$NUM_OF_PROCESSORS
make install

##libpng
install_with_configure_script http://downloads.sourceforge.net/libpng/libpng-1.6.23.tar.xz

#freetype (without harfbuz)
rm -rf "$PREFIX/include/freetype2/freetype"
cd $TEMP
if [ ! -d "freetype-2.6" ]; then
   wget http://download.savannah.gnu.org/releases/freetype/freetype-2.6.tar.gz
   tar xvf freetype-2.6.tar.gz
fi
cd freetype-2.6
./configure --prefix=$PREFIX --without-harfbuzz
make -j$NUM_OF_PROCESSORS
make install

#fontconfig
cd $TEMP
if [ ! -d "fontconfig-2.12.0" ]; then
   wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.0.tar.gz
   tar xvf fontconfig-2.12.0.tar.gz
fi
cd fontconfig-2.12.0
./configure --prefix=$PREFIX --enable-libxml2
make -j$NUM_OF_PROCESSORS
make install

#xorg
[[ -f "$PREFIX/include/GL/glu.h" ]] && rm "$PREFIX/include/GL/glu.h"

install_with_configure_script https://www.x.org/releases/individual/util/util-macros-1.19.0.tar.gz

install_with_configure_script https://www.x.org/releases/individual/proto/xproto-7.0.29.tar.gz
install_with_configure_script https://www.x.org/releases/individual/proto/xextproto-7.3.0.tar.gz
install_with_configure_script https://www.x.org/releases/individual/proto/inputproto-2.3.tar.gz
install_with_configure_script https://www.x.org/releases/individual/proto/kbproto-1.0.7.tar.gz
install_with_configure_script https://www.x.org/archive/individual/proto/fontsproto-2.1.3.tar.gz
install_with_configure_script https://www.x.org/archive/individual/proto/scrnsaverproto-1.2.2.tar.gz
install_with_configure_script https://www.x.org/archive/individual/proto/renderproto-0.11.tar.gz
install_with_configure_script https://www.x.org/archive/individual/proto/xineramaproto-1.2.tar.gz
install_with_configure_script https://www.x.org/archive/individual/proto/randrproto-1.5.0.tar.gz
install_with_configure_script https://www.x.org/archive/individual/proto/resourceproto-1.2.0.tar.gz
install_with_configure_script https://www.x.org/archive/individual/proto/recordproto-1.14.2.tar.gz
install_with_configure_script https://www.x.org/archive/individual/proto/videoproto-2.3.3.tar.gz
install_with_configure_script https://www.x.org/archive/individual/proto/xf86dgaproto-2.1.tar.gz
install_with_configure_script https://www.x.org/archive/individual/proto/xf86driproto-2.1.1.tar.gz
install_with_configure_script https://www.x.org/archive/individual/proto/dmxproto-2.3.tar.gz

install_with_configure_script https://www.x.org/releases/individual/lib/xtrans-1.3.5.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libX11-1.5.0.tar.gz
install_with_configure_script https://www.x.org/releases/individual/lib/libXext-1.2.0.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libFS-1.0.7.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libICE-1.0.9.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libSM-1.2.2.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXScrnSaver-1.2.2.tar.gz
install_with_configure_script https://www.x.org/releases/individual/lib/libXt-1.1.5.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXmu-1.1.2.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXpm-3.5.11.tar.gz
install_with_configure_script https://www.x.org/releases/individual/lib/libXaw-1.0.13.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXfixes-5.0.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXcomposite-0.4.4.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXrender-0.9.8.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXcursor-1.1.14.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXdamage-1.1.tar.gz 
install_with_configure_script https://www.x.org/archive/individual/lib/libfontenc-1.1.3.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXfont2-2.0.1.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXft-2.3.2.tar.gz
install_with_configure_script https://www.x.org/releases/individual/lib/libXi-1.7.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXinerama-1.1.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXrandr-1.4.2.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXres-1.0.7.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXtst-1.2.2.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXv-1.0.9.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXvMC-1.0.8.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXxf86dga-1.1.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libXxf86vm-1.1.3.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libdmx-1.1.3.tar.gz 
install_with_configure_script https://www.x.org/archive/individual/lib/libpciaccess-0.13.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libxkbfile-1.0.9.tar.gz
install_with_configure_script https://www.x.org/archive/individual/lib/libxshmfence-1.2.tar.gz
install_with_configure_script https://www.x.org/releases/individual/lib/pixman-0.34.0.tar.gz
install_with_configure_script https://www.x.org/releases/individual/lib/libXau-1.0.8.tar.gz

##ogre3d
mkdir -p $PREFIX/include/GL
if [ ! -f "$PREFIX/include/GL/glu.h" ]; then
   ln -s /cm/shared/apps/easybuild.org-2.6/software/CUDA/7.5.18/extras/CUPTI/include/GL/glu.h $PREFIX/include/GL/glu.h #hack (no other glu.h available)
fi
#ogre's cmake searches in freetype2/freetype dir
cd $PREFIX/include/freetype2 && ln -s ../freetype2 freetype
cd $TEMP
if [ ! -d "sinbad-ogre-525a7f3bcd4e" ]; then
   wget https://bitbucket.org/sinbad/ogre/get/v1-8-1.tar.gz
   tar xvzf v1-8-1.tar.gz
fi
cd sinbad-ogre-525a7f3bcd4e
[[ -d build ]] && rm -rf build
mkdir build && cd build
cmake .. \
    -DCMAKE_CXX_FLAGS="-Wno-narrowing" \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DOGRE_INSTALL_SAMPLES=FALSE \
    -DOGRE_INSTALL_DOCS=FALSE \
    -DOGRE_INSTALL_SAMPLES_SOURCE=FALSE \
    -DCMAKE_BUILD_TYPE=Release \
    2>&1 | tee output-cmake
make -j$NUM_OF_PROCESSORS 2>&1 | tee output-make
make install

##expat
install_with_configure_script https://sourceforge.net/projects/expat/files/expat/2.2.0/expat-2.2.0.tar.bz2

##dbus
install_with_configure_script http://dbus.freedesktop.org/releases/dbus/dbus-1.10.6.tar.gz

##qt
cd $TEMP
if [ ! -d "qt-everywhere-opensource-src-4.8.7" ]; then
   wget http://download.qt-project.org/official_releases/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz
   tar xvf qt-everywhere-opensource-src-4.8.7.tar.gz
fi
cd qt-everywhere-opensource-src-4.8.7
yes | ./configure --prefix=$PREFIX -opensource 2>&1 | tee output-configure
make -j$NUM_OF_PROCESSORS 2>&1 | tee output-make
make install 2>&1 | tee output-makeinstall

##protobuf
cd $TEMP
if [ ! -d "protobuf-3.0.0-beta-4" ]; then
   wget https://github.com/google/protobuf/archive/v3.0.0-beta-4.tar.gz
   tar xvf v3.0.0-beta-4.tar.gz
fi
cd protobuf-3.0.0-beta-4
./autogen.sh 2>&1 | tee output-autogen
./configure --prefix=$PREFIX 2>&1 | tee output-configure
make -j$NUM_OF_PROCESSORS  2>&1 | tee output-make
make install 2>&1 | tee output-makeinstall

##libffi
install_with_configure_script ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz

##glib
install_with_configure_script http://ftp.gnome.org/pub/gnome/sources/glib/2.48/glib-2.48.1.tar.xz

##gts
install_with_configure_script https://sourceforge.net/projects/gts/files/gts/0.7.6/gts-0.7.6.tar.gz

##gazebo
cd $TEMP
if [ ! -d "osrf-gazebo-9bc8cb494795" ]; then
   wget https://bitbucket.org/osrf/gazebo/get/gazebo7_7.3.1.tar.bz2
   tar xvf gazebo7_7.3.1.tar.bz2
fi
cd osrf-gazebo-9bc8cb494795
patch < $SCRIPT_PATH/patches/gazebo/CMakeLists.txt.patch
[[ -d build ]] && rm -rf build
mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DENABLE_TESTS_COMPILATION:BOOL=False .. 2>&1 | tee output-cmake
make -j$NUM_OF_PROCESSORS 2>&1 | tee output-make
make install

