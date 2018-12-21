#!/bin/bash

set -e


#
# Arm64 Device
#

make clean

export LDFLAGS="-m64 -pthread -pie -static-libstdc++"
export CFLAGS="-m64 -pipe -no-cpp-precomp"
export CXXFLAGS="-m64 -pipe -no-cpp-precomp"
export AR=/opt/aarch64-linux-android-clang/bin/aarch64-linux-android-ar
export AS=/opt/aarch64-linux-android-clang/bin/aarch64-linux-android-clang
export CC=/opt/aarch64-linux-android-clang/bin/aarch64-linux-android-clang
export CXX=/opt/aarch64-linux-android-clang/bin/aarch64-linux-android-clang++
export STRIP=/opt/aarch64-linux-android-clang/bin/aarch64-linux-android-strip
export RANLIB=/opt/aarch64-linux-android-clang/bin/aarch64-linux-android-ranlib
../dist/configure --host=aarch64-linux-android --prefix=`pwd`/build-android/ --enable-cxx  --enable-shared=no --with-repmgr-ssl=no

make

make install

