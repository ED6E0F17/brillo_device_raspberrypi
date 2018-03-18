/*
 * Copyright (C) 2015 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef __WIFI_DRIVER_HAL_H__
#define __WIFI_DRIVER_HAL_H__

#include <stdint.h>

#include <hardware/hardware.h>

__BEGIN_DECLS

/**
 * The WiFi Driver HAL module is meant to control the setup of WiFi
 * drivers, and not related to actual control of the devices themselves.
 * Primarily this is meant to allow initialialization of the device and
 * to select between client and AP modes.  On setup of these modes this
 * HAL allows the caller to retrieve the interface name that has been
 * setup.
 */

#define WIFI_DRIVER_HEADER_VERSION 1
#define WIFI_DRIVER_DEVICE_API_VERSION_0_1 \
    HARDWARE_MODULE_API_VERSION_2(0, 1, WIFI_DRIVER_HEADER_VERSION)

/**
 * The id of this module.
 */
#define WIFI_DRIVER_HARDWARE_MODULE_ID "wifi_driver"

/**
 * The id of the main WiFi driver device.
 */
#define WIFI_DRIVER_DEVICE_ID_MAIN "wifi_driver"

typedef enum {
  WIFI_SUCCESS = 0,
  WIFI_ERROR_NONE = 0,
  WIFI_ERROR_UNKNOWN = -1,
  WIFI_ERROR_NOT_SUPPORTED = -2,
  WIFI_ERROR_NOT_AVAILABLE = -3,
  WIFI_ERROR_INVALID_ARGS = -4,
  WIFI_ERROR_TIMED_OUT = -5,
} wifi_driver_error;

typedef enum {
  WIFI_MODE_STATION = 0,
  WIFI_MODE_AP = 1
} wifi_driver_mode;

#define DEFAULT_WIFI_DEVICE_NAME_SIZE 16

typedef struct wifi_driver_device {
  hw_device_t common;

  /**
   * Initialize the driver.  Network devices may or may not appear as
   * a result.
   *
   * @return WIFI_SUCCESS if successful, or appropriate wifi_driver_error.
   */
  wifi_driver_error (* wifi_driver_initialize)();

  /**
   * Start up the device in a specified mode.  It is guaranteed that the
   * wifi_driver_initialize function has been called prior to this.  This
   * function can be called multiple times to switch between modes.
   *
   * @param mode mode to start the driver up in.
   * @param wifi_device_name_buf name of the device created (on success).
   * @param wifi_device_name_size number of bytes available in device_name.
   *
   * @return WIFI_SUCCESS if successful, or appropriate wifi_driver_error.
   */
  wifi_driver_error (* wifi_driver_set_mode)(wifi_driver_mode mode,
                                             char* wifi_device_name_buf,
                                             size_t wifi_device_name_size);
} wifi_driver_device_t;

/** convenience API for opening and closing a device */
static inline int wifi_driver_open(
    const hw_module_t* module,
    wifi_driver_device_t** device) {
  return module->methods->open(
      module, WIFI_DRIVER_DEVICE_ID_MAIN, (struct hw_device_t**)device);
}

static inline int wifi_driver_close(wifi_driver_device_t* device) {
    return device->common.close(&device->common);
}

__END_DECLS

#endif  /* __WIFI_DRIVER_HAL_H__ */
