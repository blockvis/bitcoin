#!/bin/bash

set -e

#
# Simulator
#

make clean

SDKROOT=`xcrun -sdk iphonesimulator --show-sdk-path`
export LDFLAGS="-arch x86_64 -L$SDKROOT/usr/lib/system/"
export CFLAGS="-arch x86_64 -pipe -no-cpp-precomp --sysroot=$SDKROOT"
export CXXFLAGS="-arch x86_64 -pipe -no-cpp-precomp --sysroot=$SDKROOT"
export CC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
export CXX="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"
../dist/configure --host=aarch64-apple-darwin --prefix=`pwd`/build-ios-simulator/ --enable-cxx  --enable-shared=no --with-repmgr-ssl=no

make

make install


#
# Device
#

make clean

SDKROOT=`xcrun -sdk iphoneos --show-sdk-path`
export LDFLAGS="-arch arm64 -L$SDKROOT/usr/lib/system/"
export CFLAGS="-arch arm64 -pipe -no-cpp-precomp -miphoneos-version-min=11.0 --sysroot=$SDKROOT"
export CXXFLAGS="-arch arm64 -pipe -no-cpp-precomp -miphoneos-version-min=11.0 --sysroot=$SDKROOT"
export CC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
export CXX="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"
../dist/configure --host=aarch64-apple-darwin --prefix=`pwd`/build-ios-device/ --enable-cxx  --enable-shared=no --with-repmgr-ssl=no

make

make install


#
# Fat static library
#

mkdir -p ./build-ios/{include,lib}
cp -a ./build-ios-device/include/ ./build-ios/include/
lipo ./build-ios-device/lib/libdb-18.1.a ./build-ios-simulator/lib/libdb-18.1.a -create -output ./build-ios/lib/libdb-18.1.a
lipo ./build-ios-device/lib/libdb_cxx-18.1.a ./build-ios-simulator/lib/libdb_cxx-18.1.a -create -output ./build-ios/lib/libdb_cxx-18.1.a
