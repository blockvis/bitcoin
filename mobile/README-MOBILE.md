iOS & Android
=============

Build for macOS
---------------

    brew install automake berkeley-db4 libtool boost miniupnpc openssl pkg-config protobuf libevent
    ./autogen.sh
    ./configure --disable-wallet --without-gui --with-daemon=yes --with-utils=no \
        --disable-tests --disable-bench --enable-asm=no \
        --enable-shared=no --enable-static=yes --with-incompatible-bdb \
        --disable-hardening --disable-ccache --disable-zmq --disable-man --without-miniupnpc \
        --without-rapidcheck --without-qrencode -with-gui=no
    make -j4

Build for iOS
-------------

Build for Android
-----------------

Running
-------

    ./bitcoind --prune=550

Links
-----
https://github.com/bitcoin/bitcoin/blob/master/doc/build-osx.md  
https://github.com/Sjors/iOS-bitcoin-full-node  
https://github.com/bitcoin/bitcoin/issues/11720  
https://github.com/bitcoin/bitcoin/pull/9483  
https://en.bitcoin.it/wiki/Running_Bitcoin  
https://en.bitcoinwiki.org/wiki/Simplified_Payment_Verification  
https://en.bitcoin.it/wiki/Thin_Client_Security  
https://github.com/keeshux/bitcoinspv  

