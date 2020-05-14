### binutils 
git clone https://android.googlesource.com/toolchain/binutils     
build ld with android ndk    

### hwloc v2.0.4     
0001-Weak-definitions-of-faccessat-getline-for-android.patch applied    

### ncurses-6.2    

### libtool     
git clone git://git.savannah.gnu.org/libtool.git    
commit b9b44533fbf7c7752ffd255c3d09cc360e24183b     

### llvm    
Download source code from https://android.googlesource.com. LLVM and CLANG need to be exact the same version as the android ndk clang.      
In llvm/CMakeLists.txt: force disable assertions. option(LLVM\_ENABLE\_ASSERTIONS "Enable assertions" OFF)    
Build LLVM and CLANG with Release
Build executable binaries for x86 and copy those files to llvm/bin/     
Build static libraries for aarch64 and put them in llvm/lib/      

