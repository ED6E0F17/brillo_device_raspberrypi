#!/bin/bash

#
# Copyright 2015 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

array=( "$@" )

KERNEL_PATH=${array[0]}
OUTPUT=${array[1]}
TARGET_ARCH=${array[2]}
TARGET_CROSS_COMPILE=${array[3]}

unset "array[0]"
unset "array[1]"
unset "array[2]"
unset "array[3]"

cd $KERNEL_PATH

ARCH=$TARGET_ARCH CROSS_COMPILE=$TARGET_CROSS_COMPILE ./scripts/kconfig/merge_config.sh -O $OUTPUT ${array[*]}
