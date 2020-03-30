# Scripts for building llvm

INSTALL_DIR=$HOME/data/llvm9_x86-out/

[ ! -d "$INSTALL_DIR" ] && mkdir $INSTALL_DIR

CC=gcc
CXX=g++


cmake -G "Unix Makefiles" \
	-DLLVM_ENABLE_PROJECTS="clang;llvm;libclc" \
	-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_COMPILER=$CC \
	-DCMAKE_CXX_COMPILER=$CXX \
	-DLLVM_TARGETS_TO_BUILD="AArch64;ARM" \
	-DLLVM_DEFAULT_TARGET_TRIPLE=aarch64-linux-android \
	-DLIBCLANG_BUILD_STATIC=ON \
	../llvm

make -j4
make install
