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

# Targets for builing kernels
# The following must be set before including this file.
# TARGET_KERNEL_SRC must be set the base of a kernel tree.
# TARGET_KERNEL_DEFCONFIG must name a base kernel config.
# TARGET_KERNEL_ARCH must be set to match kernel arch.

# The following maybe set.
# TARGET_KERNEL_CROSS_COMPILE_PREFIX to override toolchain
# TARGET_PREBUILT_KERNEL to use a pre-built kernel

# Only build kernel if caller has not defined a prebuild
ifeq ($(TARGET_PREBUILT_KERNEL),)

ifeq ($(TARGET_KERNEL_SRC),)
$(error TARGET_KERNEL_SRC not defined)
endif

ifeq ($(TARGET_KERNEL_DEFCONFIG),)
$(error TARGET_KERNEL_DEFCONFIG not defined)
endif

ifeq ($(TARGET_KERNEL_ARCH),)
$(error TARGET_KERNEL_ARCH not defined)
endif

# Check target arch.
KERNEL_TOOLCHAIN_ABS := $(realpath $(TARGET_TOOLCHAIN_ROOT)/bin)
TARGET_KERNEL_ARCH := $(strip $(TARGET_KERNEL_ARCH))
KERNEL_ARCH := $(TARGET_KERNEL_ARCH)

ifeq ($(TARGET_KERNEL_ARCH), arm)
KERNEL_CROSS_COMPILE := $(KERNEL_TOOLCHAIN_ABS)/arm-linux-androideabi-
KERNEL_SRC_ARCH := arm
KERNEL_CFLAGS :=
ifdef TARGET_KERNEL_DTB
KERNEL_NAME := zImage
else
KERNEL_NAME := zImage-dtb
endif
else ifeq ($(TARGET_KERNEL_ARCH), arm64)
KERNEL_CROSS_COMPILE := $(KERNEL_TOOLCHAIN_ABS)/aarch64-linux-android-
KERNEL_SRC_ARCH := arm64
KERNEL_CFLAGS :=
KERNEL_NAME := Image
else ifeq ($(TARGET_KERNEL_ARCH), i386)
KERNEL_CROSS_COMPILE := $(KERNEL_TOOLCHAIN_ABS)/x86_64-linux-android-
KERNEL_SRC_ARCH := x86
KERNEL_CFLAGS := -mstack-protector-guard=tls
KERNEL_NAME := bzImage
else ifeq ($(TARGET_KERNEL_ARCH), x86_64)
KERNEL_CROSS_COMPILE := $(KERNEL_TOOLCHAIN_ABS)/x86_64-linux-android-
KERNEL_SRC_ARCH := x86
KERNEL_CFLAGS := -mstack-protector-guard=tls
KERNEL_NAME := bzImage
else
$(error kernel arch not supported at present)
endif

# Allow caller to override toolchain.
TARGET_KERNEL_CROSS_COMPILE_PREFIX := $(strip $(TARGET_KERNEL_CROSS_COMPILE_PREFIX))
ifneq ($(TARGET_KERNEL_CROSS_COMPILE_PREFIX),)
KERNEL_CROSS_COMPILE := $(TARGET_KERNEL_CROSS_COMPILE_PREFIX)
endif

KERNEL_GCC_NOANDROID_CHK := $(shell (echo "int main() {return 0;}" | $(KERNEL_CROSS_COMPILE)gcc -E -mno-android - > /dev/null 2>&1 ; echo $$?))
ifeq ($(strip $(KERNEL_GCC_NOANDROID_CHK)),0)
KERNEL_CFLAGS += -mno-android
endif

# Set the output for the kernel build products.
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ

KERNEL_CONFIG := $(KERNEL_OUT)/.config
KERNEL_CONFIG_REQUIRED := $(KERNEL_OUT)/.config.required

KERNEL_BIN := $(KERNEL_OUT)/arch/$(KERNEL_SRC_ARCH)/boot/$(KERNEL_NAME)

# Figure out which kernel version is being built (disregard -stable version).
KERNEL_VERSION := $(shell $(MAKE) --no-print-directory -C $(TARGET_KERNEL_SRC) -s SUBLEVEL="" kernelversion)

KERNEL_CONFIGS_DIR := device/generic/brillo/kconfig
KERNEL_CONFIGS_COMMON := $(KERNEL_CONFIGS_DIR)/common.config
KERNEL_CONFIGS_ARCH := $(KERNEL_CONFIGS_DIR)/$(KERNEL_ARCH).config
KERNEL_CONFIGS_VER := $(KERNEL_CONFIGS_DIR)/$(KERNEL_VERSION)/common.config
KERNEL_CONFIGS_VER_ARCH := $(KERNEL_CONFIGS_DIR)/$(KERNEL_VERSION)/$(KERNEL_ARCH).config

KERNEL_MERGE_CONFIG := device/generic/brillo/mergeconfig.sh


ifdef TARGET_KERNEL_DTB
KERNEL_DTB := $(KERNEL_OUT)/arch/$(KERNEL_SRC_ARCH)/boot/dts/$(TARGET_KERNEL_DTB)
$(PRODUCT_OUT)/kernel-dtb: $(KERNEL_BIN) | $(ACP)
	$(ACP) -fp $(KERNEL_DTB) $@
endif

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)


# Merge the final target kernel config.
$(KERNEL_CONFIG): $(KERNEL_OUT)
	$(TARGET_KERNEL_SRC) $(realpath $(KERNEL_OUT)) $(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) arch/$(KERNEL_SRC_ARCH)/configs/$(TARGET_KERNEL_DEFCONFIG) $(TARGET_KERNEL_CONFIGS)

$(KERNEL_BIN): $(KERNEL_OUT) $(KERNEL_CONFIG)
	$(hide) echo "Building $(KERNEL_ARCH) $(KERNEL_VERSION) kernel..."
	$(hide) rm -rf $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts
	$(MAKE) -C $(TARGET_KERNEL_SRC)  O=$(realpath $(KERNEL_OUT)) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) KCFLAGS="$(KERNEL_CFLAGS)"
	$(MAKE) -C $(TARGET_KERNEL_SRC) O=$(realpath $(KERNEL_OUT)) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) headers_install;

# If the kernel generates VDSO files, generate breakpad symbol files for them.
# VDSO libraries are mapped as linux-gate.so, so rename the symbol file to
# match as well as the filename in the first line of the .sym file.
.PHONY: $(KERNEL_BIN).vdso
$(KERNEL_BIN).vdso: $(KERNEL_BIN)
ifeq ($(BREAKPAD_GENERATE_SYMBOLS),true)
	@echo "BREAKPAD: Generating kernel VDSO symbol files."
	$(hide) set -e; \
	for sofile in `cd $(KERNEL_OUT) && find . -type f -name '*.so'`; do \
		mkdir -p $(TARGET_OUT_BREAKPAD)/kernel/$${sofile}; \
		$(BREAKPAD_DUMP_SYMS) -c $(KERNEL_OUT)/$${sofile} > $(TARGET_OUT_BREAKPAD)/kernel/$${sofile}/linux-gate.so.sym; \
		sed -i.tmp "1s/`basename "$${sofile}"`/linux-gate.so/" $(TARGET_OUT_BREAKPAD)/kernel/$${sofile}/linux-gate.so.sym; \
		rm $(TARGET_OUT_BREAKPAD)/kernel/$${sofile}/linux-gate.so.sym.tmp; \
	done
endif

ifdef TARGET_KERNEL_DTB
$(PRODUCT_OUT)/kernel: $(KERNEL_BIN) $(PRODUCT_OUT)/kernel-dtb $(KERNEL_BIN).vdso | $(ACP)
	$(ACP) -fp $< $@
else
$(PRODUCT_OUT)/kernel: $(KERNEL_BIN) $(KERNEL_BIN).vdso | $(ACP)
	$(ACP) -fp $< $@
endif

endif

