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
# define armv7-a because armv5 fails. Convert to armv6 in build system
TARGET_ARCH_VARIANT := armv7-a
#TODO Make arm6v a TARGET_CPU_VARIANT 
TARGET_CPU_VARIANT := generic
TARGET_CPU_ABI := armeabi
TARGET_CPU_ABI2 := armeabi
TARGET_KERNEL_ARCH := $(TARGET_ARCH)

TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false

BOARD_FLASH_BLOCK_SIZE := 512
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 153601024
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_USERDATAIMAGE_PARTITION_SIZE := 102410240
TARGET_USERIMAGES_USE_EXT4 := true

BOARD_USES_FULL_RECOVERY_IMAGE := true
TARGET_RECOVERY_FSTAB = device/rpi/boot/fstab
TARGET_SKIP_OTA_PACKAGE := false

PRODUCT_COPY_FILES += \
    device/rpi/phil/bsp/init.phil.rc:root/init.phil.rc \
    device/rpi/boot/fstab:root/fstab.phil

# Must be defined at the end of the file
$(call add_device_packages)
