# First get the source code::

    mkdir brillo
    cd brillo
    repo init -u git://github.com/ED6E0F17/brillo_device_raspberrypi.git -m manifest.xml
    repo sync

# For ArmV6 builds, disable some inline thumb2 code:

    rm system/extras/tests/memtest/Android.mk

# Building Brillo uses the Android build system:

    repo sync
    . build/envsetup.sh 
    lunch
    make -j3

# Lunch options:

    liz:  armv6 (PiZero).
    gert: armv6 (ModelB+).
    eben: armv7 (Model2B).

# Static IP addresses:

    set in common/init.net-setup.sh
    eth0 192.168.1.10
    usb0 10.10.10.10

