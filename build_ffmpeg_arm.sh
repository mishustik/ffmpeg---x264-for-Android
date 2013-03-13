#!/bin/bash

NDK=/your/path/to/android-ndk
PLATFORM=$NDK/platforms/android-14/arch-arm
PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86
PREFIX=/home/android-ffmpeg

function build_one
{
./configure --target-os=linux --prefix=$PREFIX \
--enable-cross-compile \
--enable-runtime-cpudetect \
--disable-asm \
--arch=arm \
--cc=$PREBUILT/bin/arm-linux-androideabi-gcc \
--cross-prefix=$PREBUILT/bin/arm-linux-androideabi- \
--disable-stripping \
--nm=$PREBUILT/bin/arm-linux-androideabi-nm \
--sysroot=$PLATFORM \
--enable-nonfree \
--enable-version3 \
--disable-everything \
--enable-gpl \
--disable-doc \
--enable-avresample \
--enable-demuxer=rtsp \
--enable-muxer=rtsp \
--disable-ffplay \
--enable-ffserver \
--enable-ffmpeg \
--disable-ffprobe \
--enable-libx264 \
--enable-encoder=libx264 \
--enable-decoder=h264 \
--enable-protocol=rtp \
--enable-hwaccels \
--enable-zlib \
--disable-devices \
--disable-avdevice \
--extra-cflags="-I/home/android-ffmpeg/include -fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=armv7-a" \
--extra-ldflags="-L/home/android-ffmpeg/lib"
make -j4 install

$PREBUILT/bin/arm-linux-androideabi-ar d libavcodec/libavcodec.a inverse.o
$PREBUILT/bin/arm-linux-androideabi-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -L$PREFIX/lib -soname libffmpeg.so -shared -nostdlib -z,noexecstack -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavfilter/libavfilter.a libavresample/libavresample.a libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a -lc -lm -lz -ldl -llog -lx264 --warn-once --dynamic-linker=/system/bin/linker $PREBUILT/lib/gcc/arm-linux-androideabi/4.4.3/libgcc.a
}

build_one
