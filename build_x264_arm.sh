#!/bin/bash

NDK=/your/path/to/android-ndk
PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.4.3/prebuilt
PLATFORM=$NDK/platforms/android-14/arch-arm
PREFIX=/home/android-ffmpeg

./configure --prefix=$PREFIX \
--enable-static \
--enable-pic \
--disable-asm \
--disable-cli \
--host=arm-linux \
--cross-prefix=$PREBUILT/linux-x86/bin/arm-linux-androideabi- \
--sysroot=$PLATFORM

make
sudo make install
sudo ldconfig
