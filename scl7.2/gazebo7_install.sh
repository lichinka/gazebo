#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_PATH/load-environment
mkdir -p $PREFIX
mkdir -p $TEMP
mkdir -p $PREFIX/include
mkdir -p $PREFIX/lib

#automatically install packages with configure.sh
function install {
   url=$1
   archive=$(basename "$1")
   folder=$(basename -s .gz "$archive" | xargs basename -s .bz2 | xargs basename -s .xz | xargs basename -s .tar)
   cd $TEMP
   [[ -d $folder ]] && rm -rf $folder
   wget $url
   tar xvf $archive
   cd $folder
   ./configure --prefix=$PREFIX --sysconfdir=$SYSCONFDIR 2>&1 | tee output-configure
   make -j$NUM_OF_PROCESSORS 2>&1 | tee output-make
   make install 2>&1 | tee output-make-install
}

#libcurl
export PKG_CONFIG_PATH=/cm/local/apps/curl/lib/pkgconfig:$PKG_CONFIG_PATH
export C_INCLUDE_PATH=/cm/local/apps/curl/include/:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/cm/local/apps/curl/include/:$CPLUS_INCLUDE_PATH

#tinyxml
cd $TEMP
wget https://sourceforge.net/projects/tinyxml/files/tinyxml/2.6.2/tinyxml_2_6_2.tar.gz/download -O tinyxml_2_6_2.tar.gz
tar xvf tinyxml_2_6_2.tar.gz
cd tinyxml
patch < $SCRIPT_PATH/patches/tinyxml/Makefile.patch
patch < $SCRIPT_PATH/patches/tinyxml/tinyxml.h.patch
make -j$NUM_OF_PROCESSORS
cp tinyxml.h $PREFIX/include
ar crf libtinyxml.a $(ls *.o | grep -v xmltest)
cp libtinyxml.a $PREFIX/lib
gcc -shared -o libtinyxml.so $(ls *.o | grep -v xmltest) 
cp libtinyxml.so $PREFIX/lib

#tinyxml2
cd $TEMP
wget https://github.com/leethomason/tinyxml2/archive/3.0.0.tar.gz -O tinyxml2-3.0.0.tar.gz
tar xvf tinyxml2-3.0.0.tar.gz 
cd tinyxml2-3.0.0
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX ..
make -j$NUM_OF_PROCESSORS 
make install

#ignition math
cd $TEMP
wget https://bitbucket.org/ignitionrobotics/ign-math/get/ignition-math2_2.5.0.tar.bz2
tar xvf ignition-math2_2.5.0.tar.bz2
cd ignitionrobotics-ign-math-6c0e329b4808 && mkdir -p build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX
make -j$NUM_OF_PROCESSORS
make install

#SD format
cd $TEMP
wget https://bitbucket.org/osrf/sdformat/get/sdformat4_4.1.1.tar.bz2
tar xvf sdformat4_4.1.1.tar.bz2
cd osrf-sdformat-10551a6e8a2c && mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX ..
make -j$NUM_OF_PROCESSORS
make install

#freeimage
cd $TEMP
wget https://sourceforge.net/projects/freeimage/files/Source%20Distribution/3.17.0/FreeImage3170.zip
unzip FreeImage3170.zip 
cd FreeImage
make -j$NUM_OF_PROCESSORS
cp Dist/lib* $PREFIX/lib 
cp Dist/FreeImage.h $PREFIX/include

##libtar
cd $TEMP
wget --no-check-certificate https://repo.or.cz/libtar.git/snapshot/0907a9034eaf2a57e8e4a9439f793f3f05d446cd.tar.gz -O libtar-1.2.2.tar.gz
tar xvf libtar-1.2.2.tar.gz
cd libtar-0907a90
autoreconf --force --install
./configure --prefix=$PREFIX \
            --disable-static \
            --disable-encap \
            --disable-epkg-install
make -j$NUM_OF_PROCESSORS
make install

install http://downloads.sourceforge.net/libpng/libpng-1.6.23.tar.xz

#freetype (without harfbuz)
cd $TEMP
wget http://download.savannah.gnu.org/releases/freetype/freetype-2.6.tar.gz
tar xvf freetype-2.6.tar.gz
cd freetype-2.6
./configure --prefix=$PREFIX --without-harfbuzz
make -j$NUM_OF_PROCESSORS
make install

#fontconfig
cd $TEMP
wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.0.tar.gz
tar xvf fontconfig-2.12.0.tar.gz
cd fontconfig-2.12.0
./configure --prefix=$PREFIX --enable-libxml2
make -j$NUM_OF_PROCESSORS
make install

#xorg
install https://www.x.org/releases/individual/util/util-macros-1.19.0.tar.gz

install https://www.x.org/releases/individual/proto/xproto-7.0.29.tar.gz
install https://www.x.org/releases/individual/proto/xextproto-7.3.0.tar.gz
install https://www.x.org/releases/individual/proto/inputproto-2.3.tar.gz
install https://www.x.org/releases/individual/proto/kbproto-1.0.7.tar.gz
install https://www.x.org/archive/individual/proto/fontsproto-2.1.3.tar.gz
install https://www.x.org/archive/individual/proto/scrnsaverproto-1.2.2.tar.gz
install https://www.x.org/archive/individual/proto/renderproto-0.11.tar.gz
install https://www.x.org/archive/individual/proto/xineramaproto-1.2.tar.gz
install https://www.x.org/archive/individual/proto/randrproto-1.5.0.tar.gz
install https://www.x.org/archive/individual/proto/resourceproto-1.2.0.tar.gz
install https://www.x.org/archive/individual/proto/recordproto-1.14.2.tar.gz
install https://www.x.org/archive/individual/proto/videoproto-2.3.3.tar.gz
install https://www.x.org/archive/individual/proto/xf86dgaproto-2.1.tar.gz
install https://www.x.org/archive/individual/proto/xf86driproto-2.1.1.tar.gz
install https://www.x.org/archive/individual/proto/dmxproto-2.3.tar.gz

install https://www.x.org/releases/individual/lib/xtrans-1.3.5.tar.gz
install https://www.x.org/archive/individual/lib/libX11-1.5.0.tar.gz
install https://www.x.org/releases/individual/lib/libXext-1.2.0.tar.gz
install https://www.x.org/archive/individual/lib/libFS-1.0.7.tar.gz
install https://www.x.org/archive/individual/lib/libICE-1.0.9.tar.gz
install https://www.x.org/archive/individual/lib/libSM-1.2.2.tar.gz
install https://www.x.org/archive/individual/lib/libXScrnSaver-1.2.2.tar.gz
install https://www.x.org/releases/individual/lib/libXt-1.1.5.tar.gz
install https://www.x.org/archive/individual/lib/libXmu-1.1.2.tar.gz
install https://www.x.org/archive/individual/lib/libXpm-3.5.11.tar.gz
install https://www.x.org/releases/individual/lib/libXaw-1.0.13.tar.gz
install https://www.x.org/archive/individual/lib/libXfixes-5.0.tar.gz
install https://www.x.org/archive/individual/lib/libXcomposite-0.4.4.tar.gz
install https://www.x.org/archive/individual/lib/libXrender-0.9.8.tar.gz
install https://www.x.org/archive/individual/lib/libXcursor-1.1.14.tar.gz
install https://www.x.org/archive/individual/lib/libXdamage-1.1.tar.gz 
install https://www.x.org/archive/individual/lib/libfontenc-1.1.3.tar.gz
install https://www.x.org/archive/individual/lib/libXfont2-2.0.1.tar.gz
install https://www.x.org/archive/individual/lib/libXft-2.3.2.tar.gz
install https://www.x.org/releases/individual/lib/libXi-1.7.tar.gz
install https://www.x.org/archive/individual/lib/libXinerama-1.1.tar.gz
install https://www.x.org/archive/individual/lib/libXrandr-1.4.2.tar.gz
install https://www.x.org/archive/individual/lib/libXres-1.0.7.tar.gz
install https://www.x.org/archive/individual/lib/libXtst-1.2.2.tar.gz
install https://www.x.org/archive/individual/lib/libXv-1.0.9.tar.gz
install https://www.x.org/archive/individual/lib/libXvMC-1.0.8.tar.gz
install https://www.x.org/archive/individual/lib/libXxf86dga-1.1.tar.gz
install https://www.x.org/archive/individual/lib/libXxf86vm-1.1.3.tar.gz
install https://www.x.org/archive/individual/lib/libdmx-1.1.3.tar.gz 
install https://www.x.org/archive/individual/lib/libpciaccess-0.13.tar.gz
install https://www.x.org/archive/individual/lib/libxkbfile-1.0.9.tar.gz
install https://www.x.org/archive/individual/lib/libxshmfence-1.2.tar.gz
install https://www.x.org/releases/individual/lib/pixman-0.34.0.tar.gz
install https://www.x.org/releases/individual/lib/libXau-1.0.8.tar.gz

#ogre
mkdir -p $PREFIX/include/GL && ln -s /cm/shared/apps/easybuild.org-2.6/software/CUDA/7.5.18/extras/CUPTI/include/GL/glu.h $PREFIX/include/GL/glu.h #hack (no other glu.h available)
mkdir -p $PREFIX/include/freetype2/freetype && cp -r $PREFIX/include/freetype2/* $PREFIX/include/freetype2/freetype #hack (ogre's cmake searches in freetype2/freetype dir)
cd $TEMP
wget wget https://bitbucket.org/sinbad/ogre/get/v1-8-1.tar.gz
tar xvf v1-8-1.tar.gz
cd sinbad-ogre-525a7f3bcd4e
[[ -d build ]] && rm -rf build
mkdir build && cd build
cmake .. \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DOGRE_INSTALL_SAMPLES=FALSE \
    -DOGRE_INSTALL_DOCS=FALSE \
    -DOGRE_INSTALL_SAMPLES_SOURCE=FALSE \
    -DCMAKE_BUILD_TYPE=Release \
    2>&1 | tee output-cmake
make -j$NUM_OF_PROCESSORS 2>&1 | tee output-make
make install

install https://sourceforge.net/projects/expat/files/expat/2.2.0/expat-2.2.0.tar.bz2
install http://dbus.freedesktop.org/releases/dbus/dbus-1.10.6.tar.gz

#qt
cd $TEMP
wget http://download.qt-project.org/official_releases/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz
tar xvf qt-everywhere-opensource-src-4.8.7.tar.gz
cd qt-everywhere-opensource-src-4.8.7
yes | ./configure --prefix=$PREFIX -opensource 2>&1 | tee output-configure
make -j$NUM_OF_PROCESSORS 2>&1 | tee output-make
make install 2>&1 | tee output-makeinstall

#protobuf
cd $TEMP
wget https://github.com/google/protobuf/archive/v3.0.0-beta-4.tar.gz
tar xvf v3.0.0-beta-4.tar.gz
cd protobuf-3.0.0-beta-4
./autogen.sh 2>&1 | tee output-autogen
./configure --prefix=$PREFIX 2>&1 | tee output-configure
make -j$NUM_OF_PROCESSORS  2>&1 | tee output-make
make install

install ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz
install http://ftp.gnome.org/pub/gnome/sources/glib/2.48/glib-2.48.1.tar.xz
install https://sourceforge.net/projects/gts/files/gts/0.7.6/gts-0.7.6.tar.gz

#gazebo
cd $TEMP
wget https://bitbucket.org/osrf/gazebo/get/gazebo7_7.3.1.tar.bz2
tar xvf gazebo7_7.3.1.tar.bz2
cd osrf-gazebo-9bc8cb494795
patch < $SCRIPT_PATH/patches/gazebo/CMakeLists.txt.patch
[[ -d build ]] && rm -rf build
mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DENABLE_TESTS_COMPILATION:BOOL=False .. 2>&1 | tee output-cmake
make -j$NUM_OF_PROCESSORS 2>&1 | tee output-make
make install

