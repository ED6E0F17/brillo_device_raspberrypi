#!/bin/bash
mkdir tmp

cp kernel.img tmp
cp ../ramdisk.img tmp
cp cmdline.ram tmp
cp config.ram tmp
cp bcm2708* tmp
FSIZE=`du tmp | cut -f 1`
dd if=/dev/zero of=tmp.img bs=1KiB count=$(($FSIZE+30))

sudo mkfs.vfat tmp.img
sudo mount -o loop tmp.img tmp

sudo cp kernel.img tmp
sudo cp ../ramdisk.img tmp
sudo cp config.ram tmp/config.txt
sudo cp cmdline.ram tmp/cmdline.txt
sudo cp bcm2708* tmp

sudo umount tmp
mv tmp.img ../usbboot.img
rm -rf tmp
