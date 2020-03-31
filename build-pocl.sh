#!/bin/bash
PWD=`pwd`
I_AM=`id -un`
MY_GROUP=`id -gn`
ANDROID_NDK=$HOME/toolchains/android-ndk-r21/
ANDROID_TOOLCHAIN=/tmp/android-toolchain_r21/
ANDROID_TOOLCHAIN_BIN=/tmp/android-toolchain_r21/bin/
ANDROID_TOOLCHAIN_SYSROOT_USR=$ANDROID_TOOLCHAIN/sysroot/usr/
ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB=$ANDROID_TOOLCHAIN/sysroot/usr/lib/aarch64-linux-android/

POCL_DEPENDENCY=$HOME/Projects/pocl/pocl-dependency/

echo "NDK standalone toolchain setup..."
$ANDROID_NDK/build/tools/make_standalone_toolchain.py \
	--arch arm64 \
	--api 26 \
	--install-dir=$ANDROID_TOOLCHAIN \
	--force

INSTALL_PREFIX=/data/data/org.pocl.libs/files/
# Create directories for PREFIX, target location in android
if [ ! -e $INSTALL_PREFIX ]; then
	sudo mkdir -p $INSTALL_PREFIX
	sudo mkdir -p $INSTALL_PREFIX/lib/pkgconfig/
	sudo chown -R $I_AM:$MY_GROUP $INSTALL_PREFIX
	sudo chmod 755 -R $INSTALL_PREFIX
fi

# Prebuilt llvm lib that run on(android) -> target(android)
# Prebuilt llvm bin that run on(x64) -> target(android)
echo "copying llvm to $ANDROID_TOOLCHAIN_SYSROOT_USR ..."
cp -rf $POCL_DEPENDENCY/llvm/* $ANDROID_TOOLCHAIN_SYSROOT_USR


echo "copying ncurses to $ANDROID_TOOLCHAIN_SYSROOT_USR ..."
cp -rf $POCL_DEPENDENCY/ncurses/* $ANDROID_TOOLCHAIN_SYSROOT_USR
ln -sf $ANDROID_TOOLCHAIN_SYSROOT_USR/lib/libncurses.a $ANDROID_TOOLCHAIN_SYSROOT_USR/lib/libcurses.a


echo "copying ltdl to $ANDROID_TOOLCHAIN_SYSROOT_USR ..."
cp -rf $POCL_DEPENDENCY/libtool/* $ANDROID_TOOLCHAIN_SYSROOT_USR


echo "copying hwloc to $ANDROID_TOOLCHAIN_SYSROOT_USR ..."
cp -rf $POCL_DEPENDENCY/hwloc/* $ANDROID_TOOLCHAIN_SYSROOT_USR


echo "copying ld to $ANDROID_TOOLCHAIN_SYSROOT_USR ..."
cp -rf $POCL_DEPENDENCY/binutils/* $ANDROID_TOOLCHAIN_SYSROOT_USR


ln -sf $ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB/libc.a $ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB/libpthread.a
ln -sf $ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB/libc.a $ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB/librt.a
ln -sf $ANDROID_TOOLCHAIN_SYSROOT_USR/include/GLES3 $ANDROID_TOOLCHAIN_SYSROOT_USR/include/GL

ln -sf $ANDROID_TOOLCHAIN_BIN/clang* $ANDROID_TOOLCHAIN_SYSROOT_USR/bin/
ln -sf $ANDROID_TOOLCHAIN_BIN/clang++ $ANDROID_TOOLCHAIN_SYSROOT_USR/bin/
ln -sf $ANDROID_TOOLCHAIN_BIN/llvm-as $ANDROID_TOOLCHAIN_SYSROOT_USR/bin/
ln -sf $ANDROID_TOOLCHAIN_BIN/llvm-link $ANDROID_TOOLCHAIN_SYSROOT_USR/bin/

export PATH=$ANDROID_TOOLCHAIN_SYSROOT_USR/bin:$ANDROID_TOOLCHAIN_BIN:$PATH
export LD_LIBRARY_PATH=$ANDROID_TOOLCHAIN_SYSROOT_USR/lib:$ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB:$LD_LIBRARY_PATH
export HOST=aarch64-linux-android
export TARGET_CPU="kryo"
export CC=$ANDROID_TOOLCHAIN_BIN/$HOST-clang
export CXX=$ANDROID_TOOLCHAIN_BIN/$HOST-clang++
export AR=$ANDROID_TOOLCHAIN_BIN/$HOST-ar
export RANLIB=$ANDROID_TOOLCHAIN_BIN/$HOST-ranlib
export LDFLAGS=" -pie "
export PYTHONPATH=$HOME/toolchains/android-ndk/python-packages:$PYTHONPATH


cmake \
	-DCMAKE_TOOLCHAIN_FILE=androideabi.cmake \
	-DCMAKE_C_COMPILER=$CC \
	-DCMAKE_CXX_COMPILER=$CXX \
	-DCMAKE_BUILD_TYPE:STRING=Debug \
	-DCMAKE_AR:FILEPATH=$HOST-ar \
	-DCMAKE_RANLIB:FILEPATH=$HOST-ranlib \
	-DCMAKE_CXX_FLAGS:STRING="-Os -fPIE -fPIC -static-libstdc++ -fuse-ld=gold -ffunction-sections -fdata-sections -fno-lto" \
	-DCMAKE_C_FLAGS:STRING="-Os -fPIE -fPIC -ffunction-sections -fdata-sections -fno-lto" \
	-DCMAKE_EXE_LINKER_FLAGS:STRING='-fno-lto -fuse-linker-plugin -Wl,--gc-sections' \
	-DCMAKE_MODULE_LINKER_FLAGS:STRING='-fno-lto -fuse-linker-plugin -Wl,--gc-sections'  \
	-DCMAKE_SHARED_LINKER_FLAGS:STRING='-fno-lto -fuse-linker-plugin -Wl,--gc-sections' \
	-DCMAKE_INSTALL_PREFIX:PATH=$PREFIX \
	-DLLC_HOST_CPU=$TARGET_CPU \
	..
