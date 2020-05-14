#!/bin/bash
# Cross compiling with configure

TOOLCHAIN_BIN=$HOME/toolchains/ndk_r21-toolchain-arm64-api26/bin
export PATH=$TOOLCHAIN_BIN:$PATH
export LD_LIBRARY_PATH=$HOME/toolchains/ndk_r21-toolchain-arm64-api26/sysroot/usr/lib:$HOME/toolchains/ndk_r21-toolchain-arm64-api26/lib64

TARGET_HOST=aarch64-linux-android

export CC=$TOOLCHAIN_BIN/$TARGET_HOST-clang
export CXX=$TOOLCHAIN_BIN/$TARGET_HOST-clang++
export CXXFLAGS=" -O2 -fPIE -fPIC -static-libstdc++ -fuse-ld=gold "
export CFLAGS=" -O2 -fPIC -fPIE -I$PWD/include -L$PWD/lib"
export LDFLAGS=" -pie "
export PYTHONPATH=$HOME/toolchains/android-ndk-r21/python-packages:$PYTHONPATH



PWD=`pwd`
INSTALL_DIR=$PWD/`basename "$PWD"`-out

./configure \
	--prefix=$INSTALL_DIR \
	--host=aarch64-linux \
	--disable-cuda \
	--disable-nvml       

make -j4
make install

