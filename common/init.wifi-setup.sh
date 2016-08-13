#!/system/bin/sh
#
# Initialize WiFi driver in station mode

setprop ro.hardware.wifi_device bcm43438
/system/bin/wifi_init client

# Set completion property.
setprop wifi-setup.complete 1
