// Copyright (C) 2024-2025 Intel Corporation
// Under the Apache License v2.0 with LLVM Exceptions. See LICENSE.TXT.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include <umf/pools/pool_scalable.h>
#include <umf/providers/provider_file_memory.h>

#include "pool_coarse.hpp"

void *getFileParamsDefault() {
    umf_file_memory_provider_params_handle_t file_params = NULL;
    umf_result_t res =
        umfFileMemoryProviderParamsCreate(FILE_PATH, &file_params);
    if (res != UMF_RESULT_SUCCESS) {
        throw std::runtime_error(
            "Failed to create File Memory Provider params");
    }

    return file_params;
}

umf_result_t destroyFileParams(void *params) {
    return umfFileMemoryProviderParamsDestroy(
        (umf_file_memory_provider_params_handle_t)params);
}

INSTANTIATE_TEST_SUITE_P(scalableCoarseFileTest, umfPoolTest,
                         ::testing::Values(poolCreateExtParams{
                             umfScalablePoolOps(), nullptr, nullptr,
                             umfFileMemoryProviderOps(), getFileParamsDefault,
                             destroyFileParams}),
                         poolCreateExtParamsNameGen);
