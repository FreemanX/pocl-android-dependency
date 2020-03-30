### binutils: pulled from android OS    
adb pull /system/bin/ld.mc
mv ld.mc ld


### hwloc v2.0.4     
0001-Weak-definitions-of-faccessat-getline-for-android.patch applied 
build with build\_hwloc.sh       	

### ncurses-6.2    

### libtool 
git clone git://git.savannah.gnu.org/libtool.git
commit b9b44533fbf7c7752ffd255c3d09cc360e24183b

### llvm
git clone https://android.googlesource.com/toolchain/llvm-project
commit 60aaffe353336fcd5afa08a24133df6673dee3f5
build executable binaries for x86 and copy those files to llvm/bin/
build static libraries for aarch64 and put them in llvm/lib/
