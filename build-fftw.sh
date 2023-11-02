#!/usr/bin/env bash
set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} ${FFTW_VERSION:?}

DIR_SRC=${SOURCE_ROOT}/fftw
DIR_INSTALL=${INSTALL_ROOT}/fftw

DOWNLOAD_URL="http://www.fftw.org/fftw-${FFTW_VERSION}.tar.gz"

if [[ ! -d ${DIR_SRC} ]]; then
    (
        mkdir -p ${DIR_SRC}
        cd ${DIR_SRC}
        wget -O- ${DOWNLOAD_URL} | tar xz --strip-components=1
    )
fi

(
    cd ${DIR_SRC}
    #../src
    #./configure --prefix=${DIR_INSTALL} --enable-mpi --enable-openmp 
    ${CMAKE_COMMAND} . -DCMAKE_INSTALL_PREFIX=${DIR_INSTALL}
    make
    make install
)
