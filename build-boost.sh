#!/usr/bin/env bash
set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} \
    ${BOOST_VERSION:?} ${BOOST_BUILD_TYPE:?} ${HPXSC_ROOT:?} \
    ${HPX_WITH_CLANG:?}

DIR_SRC=${SOURCE_ROOT}/boost
DIR_INSTALL=${INSTALL_ROOT}/boost

DOWNLOAD_URL="http://downloads.sourceforge.net/project/boost/boost/${BOOST_VERSION}/boost_${BOOST_VERSION//./_}.tar.bz2"

if [[ ! -d ${DIR_SRC} ]]; then
    (
      # Get from sourceforge
      mkdir -p ${DIR_SRC}
      cd ${DIR_SRC}
      # When using the sourceforge link
      wget -O- ${DOWNLOAD_URL} | tar xj --strip-components=1
    )
fi

(
    cd ${DIR_SRC}

    if [[ "${HPX_WITH_CLANG}" == "ON" ]]; then
        ./bootstrap.sh --prefix=${DIR_INSTALL} --with-toolset=clang
    else
        ./bootstrap.sh --prefix=${DIR_INSTALL} --with-toolset=gcc
    fi

    ./b2 -j${PARALLEL_BUILD} "${flag1}" ${flag2} --with-atomic --with-filesystem --with-program_options --with-regex --with-system --with-chrono --with-date_time --with-thread --with-iostreams ${BOOST_BUILD_TYPE} install
)
