#!/usr/bin/env bash

set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} ${LIBFABRIC_VERSION:?}

DIR_SRC=${SOURCE_ROOT}/libfabric
#DIR_BUILD=${INSTALL_ROOT}/libfabric/build
DIR_INSTALL=${INSTALL_ROOT}/libfabric

DOWNLOAD_URL="https://github.com/ofiwg/libfabric/archive/v${LIBFABRIC_VERSION}.tar.gz"

if [[ ! -d ${DIR_INSTALL} ]]; then
    (
        mkdir -p ${DIR_SRC}
        cd ${DIR_SRC}
        wget ${DOWNLOAD_URL}
        tar -xf v${LIBFABRIC_VERSION}.tar.gz
	    cd libfabric-${LIBFABRIC_VERSION}
        ./autogen.sh	
        ./configure --disable-verbs --disable-sockets --disable-usnic --disable-udp --disable-rxm --disable-rxd --disable-shm --disable-mrail --disable-tcp --enable-gni --prefix=$INSTALL_ROOT/libfabric --no-recursion
        make -j${PARALLEL_BUILD}
        make install
    )
fi
