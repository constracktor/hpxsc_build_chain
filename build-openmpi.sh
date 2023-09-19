#!/usr/bin/env bash

set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} ${OPENMPI_VERSION:?}

DIR_SRC=${SOURCE_ROOT}/openmpi
DIR_BUILD=${INSTALL_ROOT}/openmpi/build
DIR_INSTALL=${INSTALL_ROOT}/openmpi

get_download_url()
{
    echo "https://download.open-mpi.org/release/open-mpi/v${OPENMPI_VERSION::-2}/openmpi-${OPENMPI_VERSION}.tar.gz"
}

if [[ ! -d ${DIR_SRC} ]]; then
    (
        mkdir -p ${DIR_SRC}
        cd ${DIR_SRC}
        wget -O- $(get_download_url) | tar xz --strip-components=1
    )
fi

(
    unset HWLOC_VERSION
    unset PMIX_VERSION

    mkdir -p ${DIR_BUILD}
    cd ${DIR_BUILD}

    ${DIR_SRC}/configure --prefix=${DIR_INSTALL} --disable-mpi-fortran --with-hwloc=${INSTALL_ROOT}/hwloc #--with-libevent=internal
    make -j${PARALLEL_BUILD}
    make install
)
