#
# Copyright © 2018 Blockvis. All rights reserved.
#

MAKEFILE_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROJ_ROOT_DIR:=$(realpath $(MAKEFILE_DIR)/..)

IOS_ARCHS_DEVICE:="arm64"
IOS_ARCHS_SIMULATOR:="x86_64"

IOS_SDKROOT_DEVICE:=$(shell xcrun -sdk iphoneos --show-sdk-path)
IOS_SDKROOT_SIMULATOR:=$(shell xcrun -sdk iphonesimulator --show-sdk-path)

SSL_IOS_INCLUDES:=-I$(PROJ_ROOT_DIR)/../openssl/OpenSSl/include-ios
SSL_IOS_LIBS:=-L$(PROJ_ROOT_DIR)/../openssl/OpenSSl/lib-ios -lssl

CRYPTO_IOS_INCLUDES:=-I$(PROJ_ROOT_DIR)/../openssl/OpenSSl/include-ios
CRYPTO_IOS_LIBS:=-L$(PROJ_ROOT_DIR)/../openssl/OpenSSl/lib-ios -lcrypto

EVENT_IOS_INCLUDES:=-I$(PROJ_ROOT_DIR)/../libevent/libevent-dest-include/include
EVENT_IOS_LIBS:=-L$(PROJ_ROOT_DIR)/../libevent/libevent-dest-lib -levent -levent_core -levent_extra
EVENT_PTHREADS_IOS_INCLUDES:=-I$(PROJ_ROOT_DIR)/../libevent/libevent-dest-include/include
EVENT_PTHREADS_IOS_LIBS:=-L$(PROJ_ROOT_DIR)/../libevent/libevent-dest-lib -levent_pthreads

all: macos ios android


prerequisites:
	brew install automake berkeley-db4 libtool boost miniupnpc openssl pkg-config protobuf python qt libevent qrencode

#
# External prerequisites:
#		Boost for iOS: https://github.com/danoli3/ofxiOSBoost
#		Openssl for iOS: https://github.com/krzyzanowskim/OpenSSL
#		The libevent build script for iOS: https://gist.github.com/ursachec/6237515
#

macos:
	cd $(PROJ_ROOT_DIR) && \
			CC=clang \
			CXX=clang++ \
			./configure \
				--prefix=$(PROJ_ROOT_DIR)/build/$@ \
				--disable-wallet --without-gui --with-daemon=yes --with-utils=no \
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
				--with-boost=$(PROJ_ROOT_DIR)/../boost/ofxiOSBoost/libs/boost \
				--with-boost-libdir=$(PROJ_ROOT_DIR)/../boost/ofxiOSBoost/libs/boost/ios \
				--with-boost-system=boost \
				--with-boost-filesystem=boost \
				--with-boost-thread=boost \
				--with-boost-chrono=boost \
				--disable-wallet --without-gui --with-daemon=yes --with-utils=no \
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
				EVENT_PTHREADS_LIBS="$(EVENT_PTHREADS_IOS_LIBS)"
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
				--with-boost=$(PROJ_ROOT_DIR)/../boost/ofxiOSBoost/libs/boost \
				--with-boost-libdir=$(PROJ_ROOT_DIR)/../boost/ofxiOSBoost/libs/boost/ios \
				--with-boost-system=boost \
				--with-boost-filesystem=boost \
				--with-boost-thread=boost \
				--with-boost-chrono=boost \
				--disable-wallet --without-gui --with-daemon=yes --with-utils=no \
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
				EVENT_PTHREADS_LIBS="$(EVENT_PTHREADS_IOS_LIBS)"
	-@$(MAKE) -C $(PROJ_ROOT_DIR) clean 2>&1 >/dev/null || true
	make -j4 -C $(PROJ_ROOT_DIR)
	make INSTALL_TARGET=$@ install


install:
	make -j4 -C $(PROJ_ROOT_DIR) install
	cp $(PROJ_ROOT_DIR)/src/*.a $(PROJ_ROOT_DIR)/src/*.la $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/lib/
	find  $(PROJ_ROOT_DIR)/src/ -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/ \;
	find  $(PROJ_ROOT_DIR)/src/consensus -type f -name "*.h" -maxdepth 1 -mindepth 1 -exec rsync -aqz {} $(PROJ_ROOT_DIR)/build/$(INSTALL_TARGET)/include/consensus/ \;
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


ios-framework: ios-lipo


ios-lipo:
	mkdir -p $(PROJ_ROOT_DIR)/build/$@/{include,lib}
	cp -a $(PROJ_ROOT_DIR)/build/ios-device/include/* $(PROJ_ROOT_DIR)/build/$@/include
	cd $(PROJ_ROOT_DIR)/build/ios-device/lib/ && \
		libtool -static -o libbitcoincore.a libbitcoin_common.a libbitcoin_consensus.a libbitcoin_server.a libbitcoin_util.a
	cd $(PROJ_ROOT_DIR)/build/ios-simulator/lib/ && \
		libtool -static -o libbitcoincore.a libbitcoin_common.a libbitcoin_consensus.a libbitcoin_server.a libbitcoin_util.a
	lipo \
		$(PROJ_ROOT_DIR)/build/ios-device/lib/libbitcoincore.a \
		$(PROJ_ROOT_DIR)/build/ios-simulator/lib/libbitcoincore.a \
				-create -output $(PROJ_ROOT_DIR)/build/$@/lib/libbitcoincore.a


android:


clean:
	-@$(MAKE) -C $(PROJ_ROOT_DIR) clean 2>&1 >/dev/null || true
	-@rm -rf $(PROJ_ROOT_DIR)/build 2>&1 >/dev/null || true


.PHONY: all clean install macos ios ios-device ios-simulator ios-lipo ios-framework android


.SILENT: clean

