#!/bin/bash
mkdir -p tmp
mkdir -p tmpmount

cp kernel.img tmp
cp ../ramdisk.img tmp
cp cmdline.ram tmp
cp config.ram tmp
cp bcm27* tmp
cp -r overlays tmp
FSIZE=$((`du tmp |tail -n 1| cut -f 1`))
dd if=/dev/zero of=tmp.img bs=1024 count=$(($FSIZE+30))

sudo mkfs.vfat tmp.img
sudo mount -o loop tmp.img tmpmount

sudo cp -r tmp/* tmpmount
sudo umount tmpmount

mv tmp.img ../usbboot.img
rm -rf tmp
rm -rf tmpmount
