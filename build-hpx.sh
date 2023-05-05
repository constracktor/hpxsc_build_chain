#!/usr/bin/env bash

set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} ${LIB_DIR_NAME:?} ${GCC_VERSION:?} ${BUILD_TYPE:?} \
    ${CMAKE_VERSION:?} ${CMAKE_COMMAND:?} \
    ${BOOST_VERSION:?} ${BOOST_BUILD_TYPE:?} \
    ${JEMALLOC_VERSION:?} ${HWLOC_VERSION:?}${HPX_VERSION:?} \
    ${HPX_WITH_CUDA:?} ${HPX_WITH_PARCEL:?}

DIR_SRC=${SOURCE_ROOT}/hpx
DIR_BUILD=${INSTALL_ROOT}/hpx/build
DIR_INSTALL=${INSTALL_ROOT}/hpx

DOWNLOAD_URL="https://github.com/stellar-group/hpx/archive/${HPX_VERSION}.tar.gz"

if [[ ! -d ${DIR_SRC} ]]; then
    (
      mkdir -p ${DIR_SRC}
      cd ${DIR_SRC}
      wget -O- ${DOWNLOAD_URL} | tar xz --strip-components=1
    )
fi

${CMAKE_COMMAND} \
    -H${DIR_SRC} \
    -B${DIR_BUILD} \
    -DCMAKE_INSTALL_PREFIX=${DIR_INSTALL} \
    -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
    -DCMAKE_EXE_LINKER_FLAGS="${LDCXXFLAGS}" \
    -DCMAKE_SHARED_LINKER_FLAGS="${LDCXXFLAGS}" \
    -DHPX_WITH_CXX17=ON \
    -DHPX_WITH_FETCH_ASIO=ON\
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DHPX_WITH_THREAD_IDLE_RATES=ON \
    -DHPX_WITH_DISABLED_SIGNAL_EXCEPTION_HANDLERS=ON \
    -DHWLOC_ROOT=${INSTALL_ROOT}/hwloc/ \
    -DHPX_WITH_MALLOC=JEMALLOC \
    -DJEMALLOC_ROOT=${INSTALL_ROOT}/jemalloc \
    -DBOOST_ROOT=${INSTALL_ROOT}/boost \
    -DHPX_WITH_NETWORKING=${HPX_WITH_PARCEL} \
    -DHPX_WITH_PARCELPORT_MPI=${HPX_WITH_PARCEL} \
    -DHPX_WITH_MORE_THAN_64_THREADS=ON \
    -DHPX_WITH_MAX_CPU_COUNT=256 \
    -DHPX_WITH_LOGGING=OFF \
    -DHPX_WITH_EXAMPLES=OFF \
    -DHPX_WITH_TESTS=OFF \
    -DHPX_WITH_APEX=ON \
    -DAPEX_WITH_MPI=${HPX_WITH_MPI} \
    -DAPEX_WITH_CUDA=${HPX_WITH_CUDA} \
    -DHPX_WITH_CUDA=${HPX_WITH_CUDA} \
    -DHPX_WITH_GPUBLAS=${HPX_WITH_CUDA}
    #-DHPX_WITH_CUDA_ARCH=${CUDA_SM} \

${CMAKE_COMMAND} --build ${DIR_BUILD} -- -j${PARALLEL_BUILD} VERBOSE=1
${CMAKE_COMMAND} --build ${DIR_BUILD} --target install
cp ${DIR_BUILD}/compile_commands.json ${DIR_SRC}/compile_commands.json
