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

# Standard devices would usally define an SoC.
# Arm32 device.
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv5te
TARGET_CPU_VARIANT := generic
TARGET_CPU_ABI := generic
TARGET_CPU_ABI2 := armeabi
TARGET_KERNEL_ARCH := armv6k

TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false

BOARD_FLASH_BLOCK_SIZE := 512
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 122881024
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_USERDATAIMAGE_PARTITION_SIZE := 102410240
TARGET_USERIMAGES_USE_EXT4 := true

BOARD_USES_FULL_RECOVERY_IMAGE := true
TARGET_RECOVERY_FSTAB = device/rpi/fstab.device
TARGET_SKIP_OTA_PACKAGE := false

# Use clang.
USE_CLANG_PLATFORM_BUILD := true

PRODUCT_COPY_FILES += \
    device/rpi/fstab.device:root/fstab.device
