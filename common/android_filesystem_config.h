/*
 * Copyright (C) 2015 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* This file is used to define the properties of the filesystem
** images generated by build tools (mkbootfs and mkyaffs2image) and
** by the device side of adb.
*/

#include <private/android_filesystem_config.h>

#define NO_ANDROID_FILESYSTEM_CONFIG_DEVICE_DIRS

/* Rules for files.
** These rules are applied based on "first match", so they
** should start with the most specific path and work their
** way up to the root. Prefixes ending in * denote wildcards
** and will allow partial matches.
*/
static const struct fs_path_config android_device_files[] = {
    { 00555, AID_SYSTEM, AID_SHELL, CAP_MASK_LONG(CAP_NET_BIND_SERVICE), "system/bin/dnsmasq" },
    { 00700, AID_SYSTEM, AID_SHELL, CAP_MASK_LONG(CAP_BLOCK_SUSPEND),    "system/bin/nativepowerman" },
    { 00700, AID_SYSTEM, AID_SHELL, CAP_MASK_LONG(CAP_SYS_TIME),         "system/bin/tlsdated" },
    { 00700, AID_SYSTEM, AID_SHELL, CAP_MASK_LONG(CAP_NET_BIND_SERVICE), "system/bin/webservd" },
    { 00700, AID_DHCP,   AID_DBUS,  CAP_MASK_LONG(CAP_NET_ADMIN) |
                                    CAP_MASK_LONG(CAP_NET_BIND_SERVICE) |
                                    CAP_MASK_LONG(CAP_NET_RAW),          "system/bin/dhcpcd-6.8.2" },
    { 00700, AID_BLUETOOTH, AID_SHELL, CAP_MASK_LONG(CAP_BLOCK_SUSPEND) |
                                       CAP_MASK_LONG(CAP_NET_ADMIN)     |
                                       CAP_MASK_LONG(CAP_WAKE_ALARM),    "system/bin/bluetoothtbd" },
    { 00755, AID_WIFI,    AID_SHELL, CAP_MASK_LONG(CAP_NET_ADMIN) |
                                     CAP_MASK_LONG(CAP_NET_RAW),          "system/bin/apmanager" },
    { 00755, AID_WIFI,    AID_SHELL, CAP_MASK_LONG(CAP_NET_ADMIN) |
                                     CAP_MASK_LONG(CAP_NET_RAW),          "system/bin/hostapd" },
    { 00755, AID_SYSTEM,  AID_SHELL, CAP_MASK_LONG(CAP_NET_ADMIN) |
                                     CAP_MASK_LONG(CAP_NET_RAW),          "system/bin/ifconfig" },
    { 00555, AID_ROOT,   AID_SHELL, 0,                                   "system/bin/gpio" },
    { 00550, AID_ROOT,   AID_SHELL, 0,                                   "system/etc/init.firewall-setup.sh" },
    { 00550, AID_ROOT,   AID_SHELL, CAP_MASK_LONG(CAP_NET_ADMIN) |
				    CAP_MASK_LONG(CAP_NET_RAW),		 "system/etc/init.net-setup.sh" },
};
