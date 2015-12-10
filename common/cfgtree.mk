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

# This file provides a helper which loads the contents of a given file
# relative to a common root path.  The helper ensures there is consistent
# path resolution for loading and error messaging for missing or empty
# files that are required.
#
# The primary usage of this file is for loading product-level configuration
# from plaintext files. An example usage in a makefile is:
#    BRILLO_CRASH_SERVER := $(call cfgtree_get,brillo/crash_server,required)
#
# Note the use of an immediate assignment. If any other variable assignment is
# used, be sure to test that it resolves as and when expected.
#
# Populating the file is as simple as:
#    cd $PRODUCT_DIR
#    mkdir -p config/brillo
#    echo https://some.server/handle/crash.cgi > config/brillo/crash_server
#
# Any lines beginning with '#' will be ignored, but if a '#' is required, it
# can be inserted by simply starting the line with a space which will be
# stripped off during the loading process.
#
# Note, there is no central mapping of variables to files. If any files will
# be used from different contexts, be sure to keep all users in sync.
#
# For any PRODUCT_* variable set using this mechanism, it is possible to
# verify a correct assignment by calling:
#
#   m dump-products
#

# Path to load from
CFGTREE_ROOT ?= $(LOCAL_PATH)
CFGTREE_PREFIX ?= config
CFGTREE_PATH := $(CFGTREE_ROOT)/$(CFGTREE_PREFIX)

# Command to run to dump the file content.
CFGTREE_CMD ?= grep -v -e '^$(shell printf '\043')'

# $(1) is the file to load from cfgtree
#
# Returns the output of $(CFGTREE_CMD) $(1)/$(2) if the file exists.
# Normally, this is all the text excluding lines starting with '#'.
#
define cfgtree-get
$(strip \
  $(if $(filter 0,$(words $(call cfgtree-get-if-exists,$(1)))),\
    $(error Required configuration file \
            $(CFGTREE_PREFIX)/$(1) is empty or missing.),\
    $(call cfgtree-get-if-exists,$(1)))\
)
endef

define cfgtree-get-if-exists
$(strip $(shell $(CFGTREE_CMD) $(CFGTREE_PATH)/$(1) 2>/dev/null))
endef
