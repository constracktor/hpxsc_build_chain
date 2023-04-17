#!/usr/bin/env bash
set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} ${GCC_VERSION:?} ${JEMALLOC_VERSION:?}

DIR_SRC=${SOURCE_ROOT}/jemalloc
DIR_INSTALL=${INSTALL_ROOT}/jemalloc

DOWNLOAD_URL="https://github.com/jemalloc/jemalloc/releases/download/${JEMALLOC_VERSION}/jemalloc-${JEMALLOC_VERSION}.tar.bz2"

if [[ ! -d ${DIR_INSTALL} ]]; then
    (
        mkdir -p ${DIR_SRC}
        cd ${DIR_SRC}
        wget -O- ${DOWNLOAD_URL} | tar xj --strip-components=1
        ./autogen.sh
        ./configure --prefix=${DIR_INSTALL}
        make -j${PARALLEL_BUILD}
        make install
    )
fi
