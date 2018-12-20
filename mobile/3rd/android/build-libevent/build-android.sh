#!/bin/bash

set -e

CURR_DIR=`pwd`

cd libevent-2.1.8-stable

PATH=/opt/aarch64-linux-android-clang/bin:${PATH} \
			AR=/opt/aarch64-linux-android-clang/bin/aarch64-linux-android-ar \
			AS=/opt/aarch64-linux-android-clang/bin/aarch64-linux-android-clang \
			CC=/opt/aarch64-linux-android-clang/bin/aarch64-linux-android-clang \
			CXX=/opt/aarch64-linux-android-clang/bin/aarch64-linux-android-clang++ \
			STRIP=/opt/aarch64-linux-android-clang/bin/aarch64-linux-android-strip \
			RANLIB=/opt/aarch64-linux-android-clang/bin/aarch64-linux-android-ranlib \
			ANDROID_SYSROOT="$(ANDROID_NDK_ROOT)/platforms/android-27/arch-arm64" \
			CFLAGS=" -m64" \
			CXXFLAGS=" -m64" \
			LDFLAGS="-pthread -pie -static-libstdc++" \
			BOOST_CPPFLAGS="-std=c++11 -pthread" \
			TOOLCHAIN=aarch64-linux-android-clang \
    ./configure --disable-shared --enable-static --disable-debug-mode --prefix=$CURR_DIR/build-arm64 \
        --host=aarch64-linux-android

make
make install
    