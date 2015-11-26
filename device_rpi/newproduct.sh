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
#

# This script is a temporary helper to create Brillo products.

# Borrowed from envsetup.sh
# Copied here as envsetup.sh might not have run yet
function gettop
{
    local TOPFILE=build/core/envsetup.mk
    if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
        # The following circumlocution ensures we remove symlinks from TOP.
        (cd $TOP; PWD= /bin/pwd)
    else
        if [ -f $TOPFILE ] ; then
            # The following circumlocution (repeated below as well) ensures
            # that we record the true directory name and not one that is
            # faked up with symlink names.
            PWD= /bin/pwd
        else
            local HERE=$PWD
            T=
            while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
                \cd ..
                T=`PWD= /bin/pwd -P`
            done
            \cd $HERE
            if [ -f "$T/$TOPFILE" ]; then
                echo $T
            fi
        fi
    fi
}

function CreateProduct() {
  local T=$(gettop)
  echo "Creating vendor: $VENDOR product: $PRODUCT device: $DEVICE"
  mkdir -p $T/product/$VENDOR/$PRODUCT/src
  echo $AndroidProductsTemplate > $T/product/$VENDOR/$PRODUCT/AndroidProducts.mk
  echo $VendorSetupTemplate > $T/product/$VENDOR/$PRODUCT/vendorsetup.sh
  echo -e $MakeTemplate > $T/product/$VENDOR/$PRODUCT/$PRODUCT.mk
}

function PrintUsage() {
  echo "newproduct.sh <vendor_name> <product_name> <device_name>"
  exit 1
}

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] ; then
  PrintUsage
fi

VENDOR=$1
PRODUCT=$2
DEVICE=$3

AndroidProductsTemplate="PRODUCT_MAKEFILES := \
    \$(LOCAL_DIR)/$PRODUCT.mk"

VendorSetupTemplate="add_lunch_combo $PRODUCT-userdebug"
MakeTemplate="\$(call inherit-product, device/generic/brillo/brillo_base.mk)\n\
\n\
PRODUCT_NAME := $PRODUCT \n\
PRODUCT_BRAND := Brillo \n\
\n\
PRODUCT_DEVICE := $DEVICE\
\n\
PRODUCT_PACKAGES += \n"

CreateProduct
