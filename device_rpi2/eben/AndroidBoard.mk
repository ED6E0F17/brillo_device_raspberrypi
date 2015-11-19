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
#

# This has to live here for now as the variables it requires are
# not read when BoardConfig.mk is parsed.

TARGET_KERNEL_DEFCONFIG :=bcm2709_defconfig
TARGET_KERNEL_SRC :=hardware/bsp/rpi/kernel/
TARGET_KERNEL_DTB :=bcm2709-rpi-2-b.dtb
include device/rpi2/kernel.mk
