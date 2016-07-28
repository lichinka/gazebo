#!/bin/bash

SCRIPT_PATH=$(pwd)
PREFIX=$HOME/local
SYSCONFDIR=$PREFIX/etc
mkdir -p $PREFIX
TEMP=$HOME/tmp
mkdir -p $TEMP

mkdir -p $PREFIX/include
mkdir -p $PREFIX/lib

NUM_OF_PROCESSORS=$(grep -c ^processor /proc/cpuinfo)

export ACLOCAL="aclocal -I ${PREFIX}/share/aclocal"
export PATH=$PREFIX/bin:$PATH
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig:$PKG_CONFIG_PATH
export LIBRARY_PATH=$PREFIX/lib:$PREFIX/lib64
export LD_LIBRARY_PATH=$LIBRARY_PATH
export C_INCLUDE_PATH=$PREFIX/include:$INCLUDEPATH:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=$C_INCLUDE_PATH

#base dependiencies
module load CMake/3.4.1-GCC-4.9.2
module load Autotools/20150215-GCC-4.9.3-2.25
module load intel-tbb-oss/intel64/44_20160526oss
module load cuda70/toolkit/7.0.28 

#install packages with standard configuration
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

#ignition math
cd $TEMP
wget https://bitbucket.org/ignitionrobotics/ign-math/get/ignition-math2_2.5.0.tar.bz2
tar xvf ignition-math2_2.5.0.tar.bz2
cd ignitionrobotics-ign-math-6c0e329b4808 && mkdir -p build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX
make -j$NUM_OF_PROCESSORS
make install

#tiny xml
cd $TEMP
wget https://sourceforge.net/projects/tinyxml/files/tinyxml/2.6.2/tinyxml_2_6_2.tar.gz/download -O tinyxml_2_6_2.tar.gz
tar xvf tinyxml_2_6_2.tar.gz
cd tinyxml
patch < $SCRIPT_PATH/Makefile.patch
patch < $SCRIPT_PATH/tinyxml.h.patch
make -j$NUM_OF_PROCESSORS #CFLAGS="-DTIXML_USE_STL"
cp tinyxml.h $PREFIX/include
ar crf libtinyxml.a $(ls *.o | grep -v xmltest)
cp libtinyxml.a $PREFIX/lib
gcc -shared -o libtinyxml.so $(ls *.o | grep -v xmltest) 
cp libtinyxml.so $PREFIX/lib


#SD format
cd $TEMP
wget https://bitbucket.org/osrf/sdformat/get/sdformat4_4.1.1.tar.bz2
tar xvf sdformat4_4.1.1.tar.bz2
cd osrf-sdformat-10551a6e8a2c && mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX ..
make -j$NUM_OF_PROCESSORS #CFLAGS="-DTIXML_USE_STL"
make install

#protobuf
cd $TEMP
wget https://github.com/google/protobuf/archive/v3.0.0-beta-4.tar.gz
tar xvf v3.0.0-beta-4.tar.gz
cd protobuf-3.0.0-beta-4
./autogen.sh
./configure --prefix=$PREFIX
make -j$NUM_OF_PROCESSORS 
make install

#freeimage
cd $TEMP
wget https://sourceforge.net/projects/freeimage/files/Source%20Distribution/3.17.0/FreeImage3170.zip
unzip FreeImage3170.zip 
cd FreeImage
cp Dist/lib* $PREFIX/lib 
cp Dist/FreeImage.h $PREFIX/include

#openGL
#OPENGL_INCLUDE_DIR=/cm/shared/apps/cuda-8.0/extras/CUPTI/include

#libcurl
export PKG_CONFIG_PATH=/cm/local/apps/curl/lib/pkgconfig:$PKG_CONFIG_PATH

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


#xorg
install https://www.x.org/releases/individual/util/util-macros-1.19.0.tar.gz

install https://www.x.org/releases/individual/proto/xproto-7.0.29.tar.gz
install https://www.x.org/releases/individual/proto/xextproto-7.3.0.tar.gz
install https://www.x.org/releases/individual/proto/inputproto-2.3.tar.gz
install https://www.x.org/releases/individual/proto/kbproto-1.0.7.tar.gz

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

#install https://xcb.freedesktop.org/dist/xcb-proto-1.12.tar.gz

#install https://xcb.freedesktop.org/dist/libpthread-stubs-0.3.tar.gz

#install https://xcb.freedesktop.org/dist/libxcb-1.12.tar.gz

#install https://sourceforge.net/projects/libpng/files/libpng16/1.6.23/libpng-1.6.23.tar.gz

#probably useless
#install https://www.cairographics.org/releases/cairo-1.14.6.tar.xz

#install ftp://sourceware.org/pub/libffi/libffi-3.2.tar.gz

#install http://ftp.gnome.org/pub/GNOME/sources/glib/2.49/glib-2.49.4.tar.xz

#probably useless
##freetype (without harfbuz)
#cd $TEMP
#wget http://download.savannah.gnu.org/releases/freetype/freetype-2.6.tar.gz
#tar xvf freetype-2.6.tar.gz
#cd freetype-2.6
#./configure --prefix=$PREFIX --without-harfbuzz
#make -j$NUM_OF_PROCESSORS
#make install

#probably useless
#install https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.3.0.tar.bz2

#probably useless
##freetype (again, this time with harfbuzz)
#install http://download.savannah.gnu.org/releases/freetype/freetype-2.6.tar.gz

#probably useless
##fontconfig
#cd $TEMP
#wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.0.tar.gz
#tar xvf fontconfig-2.12.0.tar.gz
#cd fontconfig-2.12.0
#./configure --prefix=$PREFIX --enable-libxml2
#make -j$NUM_OF_PROCESSORS
#make install

#probably useless
##cairo (again, this time with freetype)
#install https://www.cairographics.org/releases/cairo-1.14.6.tar.xz

#probably useless
#install http://ftp.gnome.org/pub/GNOME/sources/pango/1.40/pango-1.40.1.tar.xz

install http://www.nasm.us/pub/nasm/releasebuilds/2.12/nasm-2.12.tar.gz
install https://sourceforge.net/projects/libjpeg-turbo/files/1.5.0/libjpeg-turbo-1.5.0.tar.gz
install ftp://ftp.remotesensing.org/pub/libtiff/tiff-4.0.6.tar.gz

#probably useless
#install https://download.gnome.org/sources/gdk-pixbuf/2.35/gdk-pixbuf-2.35.2.tar.xz

#probably useless
#install https://download.gnome.org/sources/atk/2.20/atk-2.20.0.tar.xz

#probably useless
#install http://launchpad.net/intltool/trunk/0.50.2/+download/intltool-0.50.2.tar.gz

#probably useless
#install https://sourceforge.net/projects/expat/files/expat/2.2.0/expat-2.2.0.tar.bz2

install http://dbus.freedesktop.org/releases/dbus/dbus-1.10.6.tar.gz

#probably useless
#install http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.18/at-spi2-core-2.18.3.tar.xz
#install http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.18/at-spi2-atk-2.18.1.tar.xz
#install http://ftp.gnome.org/pub/gnome/sources/gtk+/3.20/gtk+-3.20.6.tar.xz

#TODO: this is useless! get rid of it and all the dependencies
#install http://www.joachim-breitner.de/archive/screen-message/screen-message-0.24.tar.gz

#ogre
cd $TEMP
wget https://bitbucket.org/sinbad/ogre/get/v1-9-0.tar.bz2 -o ogre-v1-9-0.tar.bz2
tar xvf ogre-v1-9-0.tar.bz2 
cd sinbad-ogre-dd30349ea667
[[ -d build ]] && rm -rf build
mkdir build && cd build
cmake .. \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DOGRE_INSTALL_SAMPLES=FALSE \
    -DOGRE_INSTALL_DOCS=FALSE \
    -DOGRE_INSTALL_SAMPLES_SOURCE=FALSE \
    -DCMAKE_BUILD_TYPE=Release
make -j$NUM_OF_PROCESSORS
make install

install https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-0.10.36.tar.gz
install https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-0.10.36.tar.gz
install ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.0.29.tar.bz2

#qt
cd $TEMP
wget http://download.qt-project.org/official_releases/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz
tar xvf qt-everywhere-opensource-src-4.8.7.tar.gz
cd qt-everywhere-opensource-src-4.8.7
yes | ./configure --prefix=$PREFIX -opensource 2>&1 | tee output-configure
make -j$NUM_OF_PROCESSORS 2>&1 | tee output-make
make install 2>&1 | tee output-makeinstall

#gazebo
cd $TEMP
wget https://bitbucket.org/osrf/gazebo/get/gazebo7_7.3.1.tar.bz2
tar xvf gazebo7_7.3.1.tar.bz2
cd osrf-gazebo-9bc8cb494795
[[ -d build ]] && rm -rf build
mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX ..
#cmake -DOPENGL_INCLUDE_DIR=$OPENGL_INCLUDE_DIR -DCMAKE_INSTALL_PREFIX=$PREFIX ..
make -j$NUM_OF_PROCESSORS
make install

