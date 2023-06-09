#${HPXSC_ROOT:?} ${BUILD_TYPE:?}

export INSTALL_ROOT=${HPXSC_ROOT}/../build
export SOURCE_ROOT=${HPXSC_ROOT}/../src

################################################################################
# Package Configuration
################################################################################
# CMake
export CMAKE_VERSION=3.19.5

# GCC
export GCC_VERSION=10.3.0
# specific version of system GCC
#export CC_VERSION=-9

# clang
export CLANG_VERSION=release/12.x
# specific version of system clang
#export CC_CLANG_VERSION=-10

# OpenMPI
export OPENMPI_VERSION=4.1.5

# MKL version 
export MKL_VERSION=2023.0.0

# Boost
export BOOST_VERSION=1.75.0
export BOOST_ROOT=${INSTALL_ROOT}/boost
export BOOST_BUILD_TYPE=$(echo ${BUILD_TYPE/%WithDebInfo/ease} | tr '[:upper:]' '[:lower:]')

# jemalloc
export JEMALLOC_VERSION=5.2.1

# hwloc
export HWLOC_VERSION=2.9.1


# CUDA
export CUDA_VERSION=11.0.3
#export CUDA_SM=sm_80

# Kokkos
export CUDA_ARCH=VOLTA70
#export KOKKOS_CONFIG=" -DKokkos_ARCH_HSW=ON  -DKokkos_ARCH_AMPERE80=ON "
#export KOKKOS_VERSION=d1e00352fd6262fd8d08225eb7086793432db35f
#export HPX_KOKKOS_VERSION=0.2.0

# HPX
export HPX_VERSION=1.8.1

# Max number of parallel jobs
export PARALLEL_BUILD=$(grep -c ^processor /proc/cpuinfo)

export LIB_DIR_NAME=lib
