# Building Brillo uses Android build system:

    repo init -u git://github.com/ED6E0F17/brillo_device_raspberrypi.git -m manifest.xml
    repo sync
    . build/envsetup.sh 
    lunch
    make -j3

# WIP: Brillo/Weave is not open/free.

Lunch options:

    liz:  armv6 (PiZero).
    gert: armv6 (ModelB+).
    eben: armv7 (Model2B).

