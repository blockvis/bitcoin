#
# Copyright © 2018 Blockvis. All rights reserved.
#

MAKEFILE_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROJ_ROOT_DIR:=$(realpath $(MAKEFILE_DIR)/..)

#
# iOS
#
IOS_ARCHS_DEVICE:="arm64"
IOS_ARCHS_SIMULATOR:="x86_64"

IOS_SDKROOT_DEVICE:=$(shell xcrun -sdk iphoneos --show-sdk-path)
IOS_SDKROOT_SIMULATOR:=$(shell xcrun -sdk iphonesimulator --show-sdk-path)

SSL_IOS_INCLUDES:=-I$(MAKEFILE_DIR)/3rd/ios/openssl/OpenSSl/include-ios
SSL_IOS_LIBS:=-L$(MAKEFILE_DIR)/3rd/ios/openssl/OpenSSl/lib-ios -lssl

CRYPTO_IOS_INCLUDES:=-I$(MAKEFILE_DIR)/3rd/ios/openssl/OpenSSl/include-ios
CRYPTO_IOS_LIBS:=-L$(MAKEFILE_DIR)/3rd/ios/openssl/OpenSSl/lib-ios -lcrypto

EVENT_IOS_INCLUDES:=-I$(MAKEFILE_DIR)/3rd/ios/libevent/libevent-dest-include/include
EVENT_IOS_LIBS:=-L$(MAKEFILE_DIR)/3rd/ios/libevent/libevent-dest-lib -levent -levent_core -levent_extra
EVENT_PTHREADS_IOS_INCLUDES:=-I$(MAKEFILE_DIR)/3rd/ios/libevent/libevent-dest-include/include
EVENT_PTHREADS_IOS_LIBS:=-L$(MAKEFILE_DIR)/3rd/ios/libevent/libevent-dest-lib -levent_pthreads

BDB_IOS_CFLAGS:=-I$(MAKEFILE_DIR)/3rd/ios/berkeleydb/db-18.1.25/build_unix/build-ios/include
BDB_IOS_LIBS:=-L$(MAKEFILE_DIR)/3rd/ios/berkeleydb/db-18.1.25/build_unix/build-ios/lib -ldb_cxx-18.1 -ldb-18.1


#
# Android
#
SSL_ANDROID_INCLUDES:=-I$(MAKEFILE_DIR)/3rd/android/openssl/OpenSSL-For-Android/openssl-1.0.2j/include/
SSL_ANDROID_LIBS:=-L$(MAKEFILE_DIR)/3rd/android/openssl/OpenSSL-For-Android/openssl-1.0.2j/lib/arm64-v8a/ -lcrypto

CRYPTO_ANDROID_INCLUDES:=-I$(MAKEFILE_DIR)/3rd/android/openssl/OpenSSL-For-Android/openssl-1.0.2j/include/
CRYPTO_ANDROID_LIBS:=-L$(MAKEFILE_DIR)/3rd/android/openssl/OpenSSL-For-Android/openssl-1.0.2j/lib/arm64-v8a/ -lcrypto

EVENT_ANDROID_INCLUDES:=-I$(MAKEFILE_DIR)/3rd/android/libevent/build-arm64/include
EVENT_ANDROID_LIBS:=-L$(MAKEFILE_DIR)/3rd/android/libevent/build-arm64/lib -levent -levent_core -levent_extra
EVENT_PTHREADS_ANDROID_INCLUDES:=-I$(MAKEFILE_DIR)/3rd/android/libevent/build-arm64/include
EVENT_PTHREADS_ANDROID_LIBS:=-L$(MAKEFILE_DIR)/3rd/android/libevent/build-arm64/lib -levent_pthreads

BDB_ANDROID_CFLAGS:=-I$(MAKEFILE_DIR)/3rd/android/berkeleydb/db-18.1.25/build_unix/build-android/include
BDB_ANDROID_LIBS:=-L$(MAKEFILE_DIR)/3rd/android/berkeleydb/db-18.1.25/build_unix/build-android/lib -ldb_cxx-18.1 -ldb-18.1


all: macos ios


prerequisites:
	brew install automake berkeley-db4 libtool boost miniupnpc openssl pkg-config protobuf python libevent qrencode


#
# External iOS prerequisites:
#		Boost for iOS: https://github.com/danoli3/ofxiOSBoost
#		OpenSSL for iOS: https://github.com/krzyzanowskim/OpenSSL
#		The libevent build script for iOS: https://gist.github.com/ursachec/6237515
# 		BerkeleyDB for iOS: https://docs.oracle.com/cd/E17076_05/html/installation/build_unix_iphone.html
#

#
# External Android prerequisites:
#		Boost for Android: http://silverglint.com/boost-for-android/
#			and https://github.com/dec1/Boost-for-Android
#			and https://github.com/moritz-wundke/Boost-for-Android
#		OpenSSL for Android: https://scottyab.com/2017/05/how-to-build-and-integrate-openssl-into-your-android-ndk-project/
#			and https://github.com/pstanoev/OpenSSL-For-Android
#		The libevent for Android: https://stackoverflow.com/questions/11655911/cross-compiling-libevent-for-android
# 		BerkeleyDB for Android: https://docs.oracle.com/cd/E17076_05/html/installation/build_android_intro.html
#
#	Also https://github.com/greenaddress/bitcoin_ndk
#


macos:
	cd $(PROJ_ROOT_DIR) && \
			CC=clang \
			CXX=clang++ \
			./configure \
				--prefix=$(PROJ_ROOT_DIR)/build/$@ \
				--without-gui --with-daemon=yes --with-utils=no \
        --disable-tests --disable-bench --enable-asm=no \
        --enable-shared=no --enable-static=yes --with-incompatible-bdb \
        --disable-hardening --disable-ccache --disable-zmq --disable-man --without-miniupnpc \
        --without-rapidcheck --without-qrencode -with-gui=no
	-@$(MAKE) -C $(PROJ_ROOT_DIR) clean 2>&1 >/dev/null || true
	make -j4 -C $(PROJ_ROOT_DIR)
	make INSTALL_TARGET=$@ install


ios: ios-device ios-simulator ios-framework


ios-device:
	cd $(PROJ_ROOT_DIR) && \
			CC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang" \
			CXX="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++" \
			CFLAGS="-arch $(IOS_ARCHS_DEVICE) -pthread -isysroot $(IOS_SDKROOT_DEVICE) -miphoneos-version-min=11.0 $(IOS_INCLUDES) -D__IOS" \
			CXXFLAGS="-arch $(IOS_ARCHS_DEVICE) -pthread -isysroot $(IOS_SDKROOT_DEVICE) -stdlib=libc++ -std=c++11 -miphoneos-version-min=11.0 $(IOS_INCLUDES) -D__IOS" \
			LDFLAGS="-arch $(IOS_ARCHS_DEVICE) -pthread -lpthread -isysroot $(IOS_SDKROOT_DEVICE) $(IOS_LIBS)" \
			BOOST_CPPFLAGS="-arch $(IOS_ARCHS_DEVICE) -isysroot $(IOS_SDKROOT_DEVICE) -stdlib=libc++ -std=c++11 -pthread" \
			./configure \
				--prefix=$(PROJ_ROOT_DIR)/build/$@ \
				--host=aarch64-apple-darwin \
				--with-boost=$(MAKEFILE_DIR)/3rd/ios/boost/ofxiOSBoost/libs/boost \
				--with-boost-libdir=$(MAKEFILE_DIR)/3rd/ios/boost/ofxiOSBoost/libs/boost/ios \
				--with-boost-system=boost \
				--with-boost-filesystem=boost \
				--with-boost-thread=boost \
				--with-boost-chrono=boost \
				--without-gui --with-daemon=yes --with-utils=no \
        --disable-tests --disable-bench --enable-asm=no \
        --enable-shared=no --enable-static=yes --with-incompatible-bdb \
        --disable-hardening --disable-ccache --disable-zmq --disable-man --without-miniupnpc \
        --without-rapidcheck --without-qrencode -with-gui=no ac_cv_c_bigendian=no \
				SSL_CFLAGS="$(SSL_IOS_INCLUDES)" \
				SSL_LIBS="$(SSL_IOS_LIBS)" \
				CRYPTO_CFLAGS="$(CRYPTO_IOS_INCLUDES)" \
				CRYPTO_LIBS="$(CRYPTO_IOS_LIBS)" \
				EVENT_CFLAGS="$(EVENT_IOS_INCLUDES)" \
				EVENT_LIBS="$(EVENT_IOS_LIBS)" \
				EVENT_PTHREADS_CFLAGS="$(EVENT_PTHREADS_IOS_INCLUDES)" \
				EVENT_PTHREADS_LIBS="$(EVENT_PTHREADS_IOS_LIBS)" \
				BDB_CFLAGS="$(BDB_IOS_CFLAGS)" \
				BDB_LIBS="$(BDB_IOS_LIBS)"
	-@$(MAKE) -C $(PROJ_ROOT_DIR) clean 2>&1 >/dev/null || true
	make -j4 -C $(PROJ_ROOT_DIR)
	make INSTALL_TARGET=$@ install


ios-simulator:
	cd $(PROJ_ROOT_DIR) && \
			CC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang" \
			CXX="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++" \
			CFLAGS="-arch $(IOS_ARCHS_SIMULATOR) -pthread -isysroot $(IOS_SDKROOT_SIMULATOR) -miphoneos-version-min=11.0 $(IOS_INCLUDES) -D__IOS" \
			CXXFLAGS="-arch $(IOS_ARCHS_SIMULATOR) -pthread -isysroot $(IOS_SDKROOT_SIMULATOR) -stdlib=libc++ -std=c++11 -miphoneos-version-min=11.0 $(IOS_INCLUDES) -D__IOS" \
			LDFLAGS="-arch $(IOS_ARCHS_SIMULATOR) -pthread -lpthread -isysroot $(IOS_SDKROOT_SIMULATOR) $(IOS_LIBS)" \
			BOOST_CPPFLAGS="-arch $(IOS_ARCHS_SIMULATOR) -isysroot $(IOS_SDKROOT_SIMULATOR) -stdlib=libc++ -std=c++11 -pthread" \
			./configure \
				--prefix=$(PROJ_ROOT_DIR)/build/$@ \
				--host=aarch64-apple-darwin \
				--with-boost=$(MAKEFILE_DIR)/3rd/ios/boost/ofxiOSBoost/libs/boost \
				--with-boost-libdir=$(MAKEFILE_DIR)/3rd/ios/boost/ofxiOSBoost/libs/boost/ios \
				--with-boost-system=boost \
				--with-boost-filesystem=boost \
				--with-boost-thread=boost \
				--with-boost-chrono=boost \
				--without-gui --with-daemon=yes --with-utils=no \
        --disable-tests --disable-bench --enable-asm=no \
        --enable-shared=no --enable-static=yes --with-incompatible-bdb \
        --disable-hardening --disable-ccache --disable-zmq --disable-man --without-miniupnpc \
        --without-rapidcheck --without-qrencode -with-gui=no ac_cv_c_bigendian=no \
				SSL_CFLAGS="$(SSL_IOS_INCLUDES)" \
				SSL_LIBS="$(SSL_IOS_LIBS)" \
				CRYPTO_CFLAGS="$(CRYPTO_IOS_INCLUDES)" \
				CRYPTO_LIBS="$(CRYPTO_IOS_LIBS)" \
				EVENT_CFLAGS="$(EVENT_IOS_INCLUDES)" \
				EVENT_LIBS="$(EVENT_IOS_LIBS)" \
				EVENT_PTHREADS_CFLAGS="$(EVENT_PTHREADS_IOS_INCLUDES)" \
				EVENT_PTHREADS_LIBS="$(EVENT_PTHREADS_IOS_LIBS)" \
				BDB_CFLAGS="$(BDB_IOS_CFLAGS)" \
				BDB_LIBS="$(BDB_IOS_LIBS)"
	-@$(MAKE) -C $(PROJ_ROOT_DIR) clean 2>&1 >/dev/null || true
	make -j4 -C $(PROJ_ROOT_DIR)
	make INSTALL_TARGET=$@ install


install:
	make -j4 -C $(PROJ_ROOT_DIR) install
	cp $(PROJ_ROOT_DIR)/src/*.a $(PROJ_ROOT_DIR)/src/*.la $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/lib/
	cp $(PROJ_ROOT_DIR)/src/secp256k1/.libs/libsecp256k1.a $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/lib/
	cp $(PROJ_ROOT_DIR)/src/leveldb/libleveldb.a $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/lib/
	cp $(PROJ_ROOT_DIR)/src/leveldb/libleveldb_sse42.a $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/lib/
	cp $(PROJ_ROOT_DIR)/src/leveldb/libmemenv.a $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/lib/
	cp $(PROJ_ROOT_DIR)/src/univalue/.libs/libunivalue.a $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/lib/
	find  $(PROJ_ROOT_DIR)/src/ -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/ \;
	find  $(PROJ_ROOT_DIR)/src/consensus -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/consensus/ \;
	find  $(PROJ_ROOT_DIR)/src/crypto -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/crypto/ \;
	find  $(PROJ_ROOT_DIR)/src/compat -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/compat/ \;
	find  $(PROJ_ROOT_DIR)/src/util -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/util/ \;
	find  $(PROJ_ROOT_DIR)/src/config -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/config/ \;
	find  $(PROJ_ROOT_DIR)/src/script -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/script/ \;
	find  $(PROJ_ROOT_DIR)/src/primitives -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/primitives/ \;
	find  $(PROJ_ROOT_DIR)/src/support -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/support/ \;
	find  $(PROJ_ROOT_DIR)/src/index -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/index/ \;
	find  $(PROJ_ROOT_DIR)/src/rpc -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/rpc/ \;
	find  $(PROJ_ROOT_DIR)/src/policy -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/policy/ \;
	find  $(PROJ_ROOT_DIR)/src/interfaces -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/interfaces/ \;
	find  $(PROJ_ROOT_DIR)/src/univalue/include -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/ \;


ios-framework: ios-lipo
	mkdir -p $(PROJ_ROOT_DIR)/build/ios-lipo/BitcoinCore.framework/Versions/A/Headers
	cp -a $(MAKEFILE_DIR)/ios/support/BitcoinCore.h $(PROJ_ROOT_DIR)/build/ios-lipo/BitcoinCore.framework/Versions/A/Headers/BitcoinCore.h
	cp -a $(PROJ_ROOT_DIR)/build/ios-lipo/include/* $(PROJ_ROOT_DIR)/build/ios-lipo/BitcoinCore.framework/Versions/A/Headers
	cp -a $(PROJ_ROOT_DIR)/build/ios-lipo/lib/libbitcoincore.a $(PROJ_ROOT_DIR)/build/ios-lipo/BitcoinCore.framework/Versions/A/BitcoinCore
	mkdir -p $(PROJ_ROOT_DIR)/build/ios-lipo/BitcoinCore.framework/Versions/A/Resources
	cp -a $(MAKEFILE_DIR)/ios/support/Info.plist $(PROJ_ROOT_DIR)/build/ios-lipo/BitcoinCore.framework/Versions/A/Resources/Info.plist
	cd $(PROJ_ROOT_DIR)/build/ios-lipo/BitcoinCore.framework/Versions/ && ln -sfh A Current
	cd $(PROJ_ROOT_DIR)/build/ios-lipo/BitcoinCore.framework/ && ln -sfh Versions/Current/Headers Headers
	cd $(PROJ_ROOT_DIR)/build/ios-lipo/BitcoinCore.framework/ && ln -sfh Versions/Current/Resources Resources
	cd $(PROJ_ROOT_DIR)/build/ios-lipo/BitcoinCore.framework/ && ln -sfh Versions/Current/BitcoinCore BitcoinCore
	mkdir -p $(PROJ_ROOT_DIR)/build/ios-lipo/BitcoinCore.framework/Modules
	cp -a $(MAKEFILE_DIR)/ios/support/module.modulemap $(PROJ_ROOT_DIR)/build/ios-lipo/BitcoinCore.framework/Modules/module.modulemap


ios-lipo: ios-lipo-3rd
	mkdir -p $(PROJ_ROOT_DIR)/build/$@/{include,lib}
	cp -a $(PROJ_ROOT_DIR)/build/ios-device/include/* $(PROJ_ROOT_DIR)/build/$@/include
	cd $(PROJ_ROOT_DIR)/build/ios-device/lib/ && \
		libtool -static -o libbitcoincore.a libbitcoin_common.a libbitcoin_consensus.a libbitcoin_server.a libbitcoin_util.a libbitcoin_wallet.a \
				libsecp256k1.a libleveldb.a libleveldb_sse42.a libmemenv.a libbitcoinconsensus.a libboost.a libcrypto.a libssl.a \
				libevent.a libevent_core.a libevent_extra.a libevent_pthreads.a \
				libunivalue.a libdb-18.1.a libdb_cxx-18.1.a
	cd $(PROJ_ROOT_DIR)/build/ios-simulator/lib/ && \
		libtool -static -o libbitcoincore.a libbitcoin_common.a libbitcoin_consensus.a libbitcoin_server.a libbitcoin_util.a libbitcoin_wallet.a \
				libsecp256k1.a libleveldb.a libleveldb_sse42.a libmemenv.a libbitcoinconsensus.a libboost.a libcrypto.a libssl.a \
				libevent.a libevent_core.a libevent_extra.a libevent_pthreads.a \
				libunivalue.a libdb-18.1.a libdb_cxx-18.1.a
	lipo \
		$(PROJ_ROOT_DIR)/build/ios-device/lib/libbitcoincore.a \
		$(PROJ_ROOT_DIR)/build/ios-simulator/lib/libbitcoincore.a \
				-create -output $(PROJ_ROOT_DIR)/build/$@/lib/libbitcoincore.a
		-@file $(PROJ_ROOT_DIR)/build/$@/lib/libbitcoincore.a


ios-lipo-3rd:
	lipo $(MAKEFILE_DIR)/3rd/ios/boost/ofxiOSBoost/libs/boost/ios/libboost.a -thin arm64 -output $(PROJ_ROOT_DIR)/build/ios-device/lib/libboost.a
	lipo $(MAKEFILE_DIR)/3rd/ios/boost/ofxiOSBoost/libs/boost/ios/libboost.a -thin x86_64 -output $(PROJ_ROOT_DIR)/build/ios-simulator/lib/libboost.a
	lipo $(MAKEFILE_DIR)/3rd/ios/openssl/OpenSSL/lib-ios/libcrypto.a -thin arm64 -output $(PROJ_ROOT_DIR)/build/ios-device/lib/libcrypto.a
	lipo $(MAKEFILE_DIR)/3rd/ios/openssl/OpenSSL/lib-ios/libcrypto.a -thin x86_64 -output $(PROJ_ROOT_DIR)/build/ios-simulator/lib/libcrypto.a
	lipo $(MAKEFILE_DIR)/3rd/ios/openssl/OpenSSL/lib-ios/libssl.a -thin arm64 -output $(PROJ_ROOT_DIR)/build/ios-device/lib/libssl.a
	lipo $(MAKEFILE_DIR)/3rd/ios/openssl/OpenSSL/lib-ios/libssl.a -thin x86_64 -output $(PROJ_ROOT_DIR)/build/ios-simulator/lib/libssl.a
	lipo $(MAKEFILE_DIR)/3rd/ios/libevent/libevent-dest-lib/libevent.a -thin arm64 -output $(PROJ_ROOT_DIR)/build/ios-device/lib/libevent.a
	lipo $(MAKEFILE_DIR)/3rd/ios/libevent/libevent-dest-lib/libevent.a -thin x86_64 -output $(PROJ_ROOT_DIR)/build/ios-simulator/lib/libevent.a
	lipo $(MAKEFILE_DIR)/3rd/ios/libevent/libevent-dest-lib/libevent_core.a -thin arm64 -output $(PROJ_ROOT_DIR)/build/ios-device/lib/libevent_core.a
	lipo $(MAKEFILE_DIR)/3rd/ios/libevent/libevent-dest-lib/libevent_core.a -thin x86_64 -output $(PROJ_ROOT_DIR)/build/ios-simulator/lib/libevent_core.a
	lipo $(MAKEFILE_DIR)/3rd/ios/libevent/libevent-dest-lib/libevent_extra.a -thin arm64 -output $(PROJ_ROOT_DIR)/build/ios-device/lib/libevent_extra.a
	lipo $(MAKEFILE_DIR)/3rd/ios/libevent/libevent-dest-lib/libevent_extra.a -thin x86_64 -output $(PROJ_ROOT_DIR)/build/ios-simulator/lib/libevent_extra.a
	lipo $(MAKEFILE_DIR)/3rd/ios/libevent/libevent-dest-lib/libevent_pthreads.a -thin arm64 -output $(PROJ_ROOT_DIR)/build/ios-device/lib/libevent_pthreads.a
	lipo $(MAKEFILE_DIR)/3rd/ios/libevent/libevent-dest-lib/libevent_pthreads.a -thin x86_64 -output $(PROJ_ROOT_DIR)/build/ios-simulator/lib/libevent_pthreads.a
	lipo $(MAKEFILE_DIR)/3rd/ios/berkeleydb/db-18.1.25/build_unix/build-ios/lib/libdb-18.1.a -thin arm64 -output $(PROJ_ROOT_DIR)/build/ios-device/lib/libdb-18.1.a
	lipo $(MAKEFILE_DIR)/3rd/ios/berkeleydb/db-18.1.25/build_unix/build-ios/lib/libdb-18.1.a -thin x86_64 -output $(PROJ_ROOT_DIR)/build/ios-simulator/lib/libdb-18.1.a
	lipo $(MAKEFILE_DIR)/3rd/ios/berkeleydb/db-18.1.25/build_unix/build-ios/lib/libdb_cxx-18.1.a -thin arm64 -output $(PROJ_ROOT_DIR)/build/ios-device/lib/libdb_cxx-18.1.a
	lipo $(MAKEFILE_DIR)/3rd/ios/berkeleydb/db-18.1.25/build_unix/build-ios/lib/libdb_cxx-18.1.a -thin x86_64 -output $(PROJ_ROOT_DIR)/build/ios-simulator/lib/libdb_cxx-18.1.a
	

android:
	cd $(PROJ_ROOT_DIR) && \
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
			LDFLAGS="-pthread -pie -static-libstdc++ -L$(MAKEFILE_DIR)/3rd/android/boost/boost_for_android/build/boost/1.69.0/libs/llvm/arm64-v8a" \
			BOOST_CPPFLAGS="-std=c++11 -pthread" \
			TOOLCHAIN=aarch64-linux-android-clang \
			./configure \
				--prefix=$(PROJ_ROOT_DIR)/build/$@ \
				--host=aarch64-linux-android \
				--with-boost=$(MAKEFILE_DIR)/3rd/android/boost/boost_for_android/build/boost/1.69.0/include \
				--with-boost-libdir=$(MAKEFILE_DIR)/3rd/android/boost/boost_for_android/build/boost/1.69.0/libs/llvm/arm64-v8a  \
				--with-boost-system=boost_system \
				--with-boost-filesystem=boost_filesystem \
				--with-boost-thread=boost_thread \
				--with-boost-chrono=boost_chrono \
				--without-gui --with-daemon=yes --with-utils=no \
        		--disable-tests --disable-bench --enable-asm=no \
        		--enable-shared=no --enable-static=yes --with-incompatible-bdb \
        		--disable-hardening --disable-ccache --disable-zmq --disable-man --without-miniupnpc \
        		--without-rapidcheck --without-qrencode -with-gui=no ac_cv_c_bigendian=no \
				SSL_CFLAGS="$(SSL_ANDROID_INCLUDES)" \
				SSL_LIBS="$(SSL_ANDROID_LIBS)" \
				CRYPTO_CFLAGS="$(CRYPTO_ANDROID_INCLUDES)" \
				CRYPTO_LIBS="$(CRYPTO_ANDROID_LIBS)" \
				EVENT_CFLAGS="$(EVENT_ANDROID_INCLUDES)" \
				EVENT_LIBS="$(EVENT_ANDROID_LIBS)" \
				EVENT_PTHREADS_CFLAGS="$(EVENT_PTHREADS_ANDROID_INCLUDES)" \
				EVENT_PTHREADS_LIBS="$(EVENT_PTHREADS_ANDROID_LIBS)" \
				BDB_CFLAGS="$(BDB_ANDROID_CFLAGS)" \
				BDB_LIBS="$(BDB_ANDROID_LIBS)"
	-@$(MAKE) -C $(PROJ_ROOT_DIR) clean 2>&1 >/dev/null || true
	make -j4 -C $(PROJ_ROOT_DIR)
	make INSTALL_TARGET=$@ install


clean:
	-@$(MAKE) -C $(PROJ_ROOT_DIR) clean 2>&1 >/dev/null || true
	-@rm -rf $(PROJ_ROOT_DIR)/build 2>&1 >/dev/null || true


.PHONY: all clean install macos ios ios-device ios-simulator ios-lipo ios-lipo-3rd ios-framework android


.SILENT: clean

