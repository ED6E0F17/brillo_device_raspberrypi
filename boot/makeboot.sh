#!/bin/bash
# make system root ramdisk
cd ../
simg2img system.img system.ext
mkdir -p rootmount
resize2fs -M system.ext
sudo mount -o loop system.ext rootmount
sudo find rootmount |sudo cpio -o --'format=newc' |gzip >system_ramdisk.img
sudo umount rootmount

#make boot partition
sudo rm -f boot/overlays/.*tmp
sudo rm -f boot/overlays/.*cmd
FSIZE=$((`du boot |tail -n 1| cut -f 1`))
dd if=/dev/zero of=bootimage.fat bs=1024 count=$(($FSIZE+50))

sudo mkfs.vfat -F 16 -s 1 bootimage.fat
sudo mount -o loop bootimage.fat rootmount
sudo cp -r boot/* rootmount

sudo umount rootmount
rm -rf rootmount
