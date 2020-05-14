#!/bin/bash

# Scripts for building llvm

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++ 


INSTALL_DIR=$HOME/Project/llvm6.0.2-static_x86/

[ ! -d "$INSTALL_DIR" ] && mkdir $INSTALL_DIR
cmake -G "Unix Makefiles" \
	-DLLVM_ENABLE_PROJECTS="clang;llvm" \
	-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_FLAGS=" -O3" \
	-DCMAKE_CXX_FLAGS=" -O3" \
	-DCMAKE_C_COMPILER=$CC \
	-DCMAKE_CXX_COMPILER=$CXX \
	-DLLVM_TARGETS_TO_BUILD="AArch64" \
	-DLIBCLANG_BUILD_STATIC=ON \
	-DLLVM_DEFAULT_TARGET_TRIPLE=aarch64-linux-android \
	../llvm


#INSTALL_DIR=$HOME/Project/llvm6.0.2-shared_x86/
#
#[ ! -d "$INSTALL_DIR" ] && mkdir $INSTALL_DIR
#cmake -G "Unix Makefiles" \
#	-DLLVM_ENABLE_PROJECTS="clang;llvm" \
#	-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
#	-DCMAKE_BUILD_TYPE=Release \
#	-DCMAKE_C_FLAGS="-s -O3" \
#	-DCMAKE_CXX_FLAGS="-s -O3" \
#	-DCMAKE_C_COMPILER=$CC \
#	-DCMAKE_CXX_COMPILER=$CXX \
#	-DLLVM_TARGETS_TO_BUILD="AArch64" \
#	-DLLVM_BUILD_LLVM_DYLIB=ON \
#	-DLLVM_DEFAULT_TARGET_TRIPLE=aarch64-linux-android \
#	../llvm

make -j8
make install
