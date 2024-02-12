#!/bin/bash
# Copyright (C) 2023-2024 Intel Corporation

# Under the Apache License v2.0 with LLVM Exceptions. See LICENSE.TXT.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# Run basic build and tests

set -ex

function sudo_password() {
	echo ${USERPASS} | sudo -Sk $*
}

build_type=${1}
compiler_c=${2}
compiler_cxx=${3}
pool_tracking=${4}
shared_library=${5}
os_provider=${6}
asan=${7}
ubsan=${8}
tsan=${9}

sudo_password chown -R $(id -u).$(id -g) .

echo "Current dir and its content: "
pwd
ls -al
echo "Free:"
echo
free -g
echo

mkdir build
cmake \
-Bbuild \
-DCMAKE_BUILD_TYPE=${build_type} \
-DCMAKE_C_COMPILER=${compiler_c} \
-DCMAKE_CXX_COMPILER=${compiler_cxx} \
-DUMF_BUILD_SHARED_LIBRARY=${shared_library} \
-DUMF_BUILD_OS_MEMORY_PROVIDER=${os_provider} \
-DUMF_ENABLE_POOL_TRACKING=${pool_tracking} \
-DUMF_FORMAT_CODE_STYLE=OFF \
-DUMF_DEVELOPER_MODE=ON \
-DUMF_BUILD_LIBUMF_POOL_JEMALLOC=ON \
-DUMF_BUILD_LIBUMF_POOL_DISJOINT=ON \
-DUMF_BUILD_LIBUMF_POOL_SCALABLE=ON \
-DUSE_ASAN=${asan} \
-DUSE_UBSAN=${ubsan} \
-DUSE_TSAN=${tsan}

cmake --build build -j $(nproc)

pushd build
ctest --output-on-failure
popd
