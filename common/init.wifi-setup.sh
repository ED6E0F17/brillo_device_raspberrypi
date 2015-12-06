#!/system/bin/sh
#
# Initialize WiFi driver in station mode

/system/bin/wifi_init client

# Set completion property.
setprop wifi-setup.complete 1
