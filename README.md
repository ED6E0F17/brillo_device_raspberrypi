# Building Brillo for armv7a-generic uses android build system:

    repo init -u https://android.googlesource.com//brillo/manifest
    . build/envsetup.sh 
    lunch
    make -j3

# WIP: some missing repos.
