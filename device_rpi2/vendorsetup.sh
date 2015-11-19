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
# This file is here to temporarily monkey patch envsetup.sh while the
# Brillo device experience is worked out.  All code in here should
# migrate to build/envsetup.sh over time.

# Execute the contents of any productsetup.sh files we can find.

# TODO(leecam): Remove this as soon as BSP refactor is done.
scan_for_brillo_products()
{
	test -n "$NO_BRILLO" && return
	local f
	for f in `test -d device/rpi2 && find -L device/rpi2 -maxdepth 4 -name 'productsetup.sh' 2> /dev/null | sort`;
	do
		echo "including $f"
		. $f
	done
}

scan_for_brillo_products

# TODO(leecam): Move this to /build
scan_for_brillo_devices()
{
  test -n "$NO_BRILLO" && return
  local f
  for f in `test -d device/ && find -L device/ -maxdepth 6 -name 'devicesetup.sh' 2> /dev/null | sort`;
  do
    echo "including $f"
    . $f
  done
}

scan_for_brillo_devices
