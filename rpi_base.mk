#
# Copyright (C) 2015 The Android Open Source Project
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

# This is a build configuration for the base of a Brillo system.
# It contains the mandatory targets required to boot a Brillo device.

BRILLO := 1
BRILLO_USE_DBUS := 1
BRILLO_USE_OMAHA := 1
BRILLO_USE_SHILL := 0
BRILLO_USE_WEAVE := 0
BRILLO_USE_BINDER := 1

USE_JACK := true
JAVA_NOT_REQUIRED := false
ANDROID_COMPILE_WITH_JACK := false
ANDROID_FORCE_JACK_ENABLED := disabled
WITH_DEXPREOPT := true

PRODUCT_IOT := true
TARGET_NO_RECOVERY := true
WITHOUT_CHECK_API := true
ANDROID_NO_TEST_CHECK := true
TARGET_BOARD_PLATFORM := rpi
BREAKPAD_GENERATE_SYMBOLS := false

# Common Brillo init scripts.
PRODUCT_COPY_FILES += \
  device/rpi/common/init.usb.rc:root/init.usb.rc \
  device/rpi/common/init.firewall-setup.sh:system/etc/init.firewall-setup.sh \
  device/rpi/common/init.net-setup.sh:system/etc/init.net-setup.sh \
  device/rpi/common/brillo.rc:system/etc/init/brillo.rc \
  device/rpi/common/consoles.rc:system/etc/init/consoles.rc \
  device/rpi/common/ueventd.rc:system/etc/init/ueventd.rc \

#  device/rpi/common/sensorservice.rc:system/etc/init/sensorservice.rc \

# Directory for init files.
TARGET_COPY_OUT_INITRCD := $(TARGET_COPY_OUT_SYSTEM)/etc/init

# Directory for Brillo build time properties.
OSRELEASED_DIRECTORY := os-release.d

# Install the BDK version.
PRODUCT_COPY_FILES += \
  tools/bdk/VERSION:system/etc/$(OSRELEASED_DIRECTORY)/bdk_version

# Include the cfgtree helpers for loading config values from disk.
include device/rpi/common/cfgtree.mk

# Template for init files.
INITRC_TEMPLATE := device/rpi/common/init.template.rc.in

PRODUCT_PACKAGES := \
  adbd \
  bootctl \
  e2fsck \
  init \
  init.rc \
  ip \
  ip6tables \
  iptables \
  libminijail \
  libstdc++ \
  libutils \
  linker \
  logcat \
  rootdev \
  shell_and_utilities \

#  services \
#  bootanimation \
#  libinput \
#  libinputflinger \
#  libpixelflinger \
#  surfaceflinger

# art packages.
#PRODUCT_PACKAGES += \
#  apache-xml \
#  bouncycastle \
#  core-libart \
#  core-oj \
#  conscrypt \
#  libmedia \
#  okhttp \

PRODUCT_PACKAGES_ENG += \
  brillo-update-payload-key \

# SELinux packages.
PRODUCT_PACKAGES += \
  sepolicy \
  file_contexts.bin \
  seapp_contexts \
  property_contexts \
  mac_permissions.xml \
  selinux_version \
  service_contexts \
  nonplat_property_contexts \
  nonplat_seapp_contexts \
  nonplat_service_contexts \
  plat_mac_permissions.xml \
  plat_property_contexts \
  plat_seapp_contexts \
  plat_service_contexts \

# Build time parameters.
PRODUCT_PACKAGES += \
  product_version \
  product_id \

# Connectivity packages.
PRODUCT_PACKAGES += \
  cacerts \
  cacerts_google \
  dhcpcd \
  dhcpcd-6.8.2 \
  iw \
  libnl \
  ping \
  wifi_init \
  wpa_supplicant \

# It only makes sense to include apmanager if WiFi is supported.
WIFI_SUPPORTED := true
WIFI_DRIVER_HAL_MODULE := wifi_driver.bcm43438
WIFI_DRIVER_HAL_PERIPHERAL := bcm43438
PRODUCT_PACKAGES += apmanager

# WIFI Firmware
BRCM_WIFI_FW_SRC := device/rpi/wifi/firmware/brcm
BRCM_WIFI_FW_DST := system/vendor/firmware/brcm

PRODUCT_COPY_FILES += \
	$(BRCM_WIFI_FW_SRC)/brcmfmac43430-sdio.bin:$(BRCM_WIFI_FW_DST)/brcmfmac43430-sdio.bin  \
	$(BRCM_WIFI_FW_SRC)/brcmfmac43430-sdio.txt:$(BRCM_WIFI_FW_DST)/brcmfmac43430-sdio.txt \
	$(BRCM_WIFI_FW_SRC)/brcmfmac43455-sdio.bin:$(BRCM_WIFI_FW_DST)/brcmfmac43455-sdio.bin  \
	$(BRCM_WIFI_FW_SRC)/brcmfmac43455-sdio.txt:$(BRCM_WIFI_FW_DST)/brcmfmac43455-sdio.txt \
	$(BRCM_WIFI_FW_SRC)/BCM43430A1.hcd:$(BRCM_WIFI_FW_DST)/BCM43430A1.hcd \
	$(BRCM_WIFI_FW_SRC)/brcmfmac43455-sdio.clm_blob:$(BRCM_WIFI_FW_DST)/brcmfmac43455-sdio.clm_blob

PRODUCT_PACKAGES += \
  3rd-party-packages \
 
PRODUCT_3RD_PARTY_PACKAGES += \
  dev-libs/wiringPi \
  media-libs/brillo-userland

# This configures filesystem capabilities.
TARGET_ANDROID_FILESYSTEM_CONFIG_H := \
device/rpi/common/android_filesystem_config.h
PRODUCT_PACKAGES += \
  fs_config_files \

# Do not build Android OTA package.
TARGET_SKIP_OTA_PACKAGE := true

# This is the list of partitions the A/B updater will update. These need to have
# two partitions each in the partition table, with the right suffix used by the
# bootloader, for example "system_a" and "system_b".
AB_OTA_UPDATER := false
AB_OTA_PARTITIONS := system

# We must select a wpa_supplicant version, or the AOSP version wont be built.
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_HOSTAPD_DRIVER := NL80211

# Settings for dhcpcd-6.8.2.
DHCPCD_USE_IPV6=yes
DHCPCD_USE_DBUS=yes

#
# Bluetooth.
#
# Dont compile for targets without WiFi support until b/25083459 is fixed.
#
ifeq ($(WIFI_SUPPORTED),true)
PRODUCT_PACKAGES += \
  bluetoothtbd \
  bluetooth-cli \

endif

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
  debug.atrace.tags.enableflags=0 \
  ro.build.shutdown_timeout=5 \

PRODUCT_COPY_FILES += \
  device/rpi/common/wpa_supplicant.conf:/system/etc/wpa_supplicant.conf \
  device/rpi/common/dhcpcd-6.8.2.conf:/system/etc/dhcpcd-6.8.2/dhcpcd.conf \

BOARD_SEPOLICY_DIRS := $(BOARD_SEPOLICY_DIRS) device/rpi/sepolicy

# TODO(jorgelo): Move into main build.
define generate-initrc-file
  @echo "Generate: $< -> $@"
  @mkdir -p $(dir $@)
  $(hide) sed -e 's?%SERVICENAME%?$(1)?g' $< > $@
  $(hide) sed -i -e 's?%ARGS%?$(2)?g' $@
  $(hide) sed -i -e 's?%GROUPS%?$(3)?g' $@
endef

# Called from the product makefile, it sets any derived defaults.
# DEPRECATED
define set-product-defaults
  $(eval PRODUCT_NAME := $$(basename $$(notdir \
    $$(filter $$(LOCAL_PATH)/%.mk,$$(MAKEFILE_LIST)))))
endef
# Returns the product name as guessed from the calling file.
define get_product_name_from_file
$(firstword $(basename $(notdir \
  $(filter $(LOCAL_PATH)/%.mk,$(MAKEFILE_LIST)))))
endef

HARDWARE_BSP_PREFIX := hardware/bsp
# New BSP helpers - move to /build once stable.
define add_peripheral
  $(eval peripheral_vendor := $(strip $(1))) \
  $(eval peripheral_name := $(strip $(2))) \
  $(eval peripheral_make_file := $(HARDWARE_BSP_PREFIX)/$(peripheral_vendor)/peripheral/$(peripheral_name)/peripheral.mk) \
  $(eval peripheral_prebuilts_make_file := $(HARDWARE_BSP_PREBUILTS_PREFIX)/$(peripheral_vendor)/hardware/peripheral/$(peripheral_name)/peripheral.mk) \
  $(if $(wildcard $(peripheral_make_file)),$(eval include $(peripheral_make_file)), \
    $(if $(wildcard $(peripheral_prebuilts_make_file)),$(eval include $(peripheral_prebuilts_make_file)), \
      $(error Can't find peripheral definition. Vendor: $(peripheral_vendor) peripheral: $(peripheral_name))))
endef

define add_device_packages
  $(eval CUSTOM_MODULES += $(DEVICE_PACKAGES))
endef

