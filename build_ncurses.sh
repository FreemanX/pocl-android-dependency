#!/bin/bash
# Cross compiling with configure

export PATH=$TOOLCHAIN_BIN:$PATH
export LD_LIBRARY_PATH=$HOME/toolchains/ndk_r21-toolchain-arm64-api26/sysroot/usr/lib:$HOME/toolchains/ndk_r21-toolchain-arm64-api26/lib64

TOOLCHAIN_BIN=$HOME/toolchains/ndk_r21-toolchain-arm64-api26/bin
TARGET_HOST=aarch64-linux-android

export CC=$TOOLCHAIN_BIN/$TARGET_HOST-clang
export CXX=$TOOLCHAIN_BIN/$TARGET_HOST-clang++
#export STRIP=$TOOLCHAIN_BIN/$TARGET_HOST-strip
#export LD=$target_host-ld
#export AR=$target_host-ar
export CXXFLAGS=" -O2 -fPIE -fPIC -static-libstdc++ -fuse-ld=gold "
export CFLAGS=" -O2 -fPIC -fPIE -I$PWD/include -L$PWD/lib"
export LDFLAGS=" -pie "

alias install="install --strip-program=$STRIP "


PWD=`pwd`
INSTALL_DIR=$PWD/`basename "$PWD"`-out

./configure \
	--prefix=$INSTALL_DIR \
	--host=aarch64-linux \
	--without-cxx \
	--without-cxx-binding \
	--disable-db-install \
	--without-progs \
	--without-manpages

make -j4
make install

