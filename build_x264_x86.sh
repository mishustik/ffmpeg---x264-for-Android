NDK=/your/path/to/android-ndk
PREBUILT=$NDK/toolchains/x86-4.4.3/prebuilt
PLATFORM=$NDK/platforms/android-14/arch-x86
PREFIX=/home/android-ffmpeg

./configure --prefix=$PREFIX \
--enable-static \
--enable-pic \
--disable-asm \
--disable-cli \
--host=i686-linux \
--cross-prefix=$PREBUILT/linux-x86/bin/i686-android-linux- \
--sysroot=$PLATFORM

make
sudo make install
sudo ldconfig
