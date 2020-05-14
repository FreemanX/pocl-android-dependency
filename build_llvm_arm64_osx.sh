#!/bin/bash
# Scripts for building llvm

TOOLCHAIN_PATH=$HOME/toolchains/ndk_r17c
TOOLCHAIN_BIN=$TOOLCHAIN_PATH/bin
SYSROOT=$TOOLCHAIN_PATH/sysroot
ARM_LIB_PATH=$HOME/Project/Libs_ARM64


export PATH=$TOOLCHAIN_BIN:$PATH
export LD_LIBRARY_PATH=$SYSROOT/usr/lib:$TOOLCHAIN_PATH/lib64:$LD_LIBRARY_PATH

TARGET_HOST=aarch64-linux-android
export CC=$TOOLCHAIN_BIN/$TARGET_HOST-clang
export CXX=$TOOLCHAIN_BIN/$TARGET_HOST-clang++
export AS=$TOOLCHAIN_BIN/$TARGET_HOST-clang
export AR=$TOOLCHAIN_BIN/$TARGET_HOST-ar
export RANLIB=$TOOLCHAIN_BIN/$TARGET_HOST-ranlib
export LD=$TOOLCHAIN_BIN/$TARGET_HOST-ld
export STRIP=$TOOLCHAIN_BIN/$TARGET_HOST-strip
export CXXFLAGS="-s -funwind-tables -O3 -fPIE -fPIC -static-libstdc++ -fuse-ld=$LD -I$ARM_LIB_PATH/include -L$ARM_LIB_PATH/lib -Wno-error=unused-command-line-argument "
export CFLAGS="-s -O3 -fPIC -fPIE -I$ARM_LIB_PATH/include -L$ARM_LIB_PATH/lib -Wno-error=unused-command-line-argument "
export LDFLAGS=" -pie "
export PYTHONPATH=$HOME/toolchains/android-ndk/python-packages:$PYTHONPATH 

PYTHON_EXECUTABLE=$TOOLCHAIN_BIN/python #for android 

INSTALL_DIR=$HOME/Project/llvm6.0.2-static_arm64
[ ! -d "$INSTALL_DIR" ] && mkdir $INSTALL_DIR
cmake -G "Unix Makefiles" \
	-DCMAKE_TOOLCHAIN_FILE=androideabi.cmake \
	-DCMAKE_CROSSCOMPILING=True \
	-DLLVM_TARGET_ARCH=AArch64 \
	-DLLVM_ENABLE_PROJECTS="clang;llvm" \
	-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
	-DCMAKE_BUILD_TYPE=Release \
	-DLLVM_TABLEGEN=$HOME/Project/toolchain6.0.2/build/bin/llvm-tblgen \
	-DCLANG_TABLEGEN=$HOME/Project/toolchain6.0.2/build/bin/clang-tblgen \
	-DLLVM_TARGETS_TO_BUILD="AArch64" \
	-DLLVM_DEFAULT_TARGET_TRIPLE=$TARGET_HOST \
	-DLIBCLANG_BUILD_STATIC=ON \
	-DLLVM_ENABLE_DIA_SDK=OFF \
	../llvm

# Build shared LLVM and clang library
#INSTALL_DIR=$HOME/Project/llvm6.0.2-shared_arm64
#[ ! -d "$INSTALL_DIR" ] && mkdir $INSTALL_DIR
#cmake -G "Unix Makefiles" \
#	-DCMAKE_TOOLCHAIN_FILE=androideabi.cmake \
#	-DCMAKE_CROSSCOMPILING=True \
#	-DLLVM_TARGET_ARCH=AArch64 \
#	-DLLVM_ENABLE_PROJECTS="clang;llvm" \
#	-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
#	-DCMAKE_BUILD_TYPE=Release \
#	-DLLVM_TABLEGEN=$HOME/Project/toolchain6.0.2/build/bin/llvm-tblgen \
#	-DCLANG_TABLEGEN=$HOME/Project/toolchain6.0.2/build/bin/clang-tblgen \
#	-DLLVM_TARGETS_TO_BUILD="AArch64" \
#	-DLLVM_DEFAULT_TARGET_TRIPLE=$TARGET_HOST \
#	-DLLVM_ENABLE_DIA_SDK=OFF \
#	-DLLVM_BUILD_LLVM_DYLIB=ON \
#	../llvm

rm -rf ./NATIVE
make -j8
make install 
