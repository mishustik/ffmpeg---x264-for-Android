#!/bin/bash

NDK=/your/path/to/android-ndk
PLATFORM=$NDK/platforms/android-14/arch-x86
PREBUILT=$NDK/toolchains/x86-4.4.3/prebuilt/linux-x86
PREFIX=/home/android-ffmpeg

function build_one
{
./configure --target-os=linux --prefix=$PREFIX \
--enable-cross-compile \
--enable-runtime-cpudetect \
--disable-asm \
--arch=x86 \
--cc=$PREBUILT/bin/i686-android-linux-gcc \
--cross-prefix=$PREBUILT/bin/i686-android-linux- \
--disable-stripping \
--nm=$PREBUILT/bin/i686-android-linux-nm \
--sysroot=$PLATFORM \
--enable-nonfree \
--enable-version3 \
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
--disable-avfilter \
--extra-cflags="-I/home/android-ffmpeg/include -march=native" \
--extra-ldflags="-L/home/android-ffmpeg/lib"
make -j4 install

$PREBUILT/bin/i686-android-linux-ar d libavcodec/libavcodec.a inverse.o
$PREBUILT/bin/i686-android-linux-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -L$PREFIX/lib -soname libffmpeg.so -shared -nostdlib -z,noexecstack -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavresample/libavresample.a libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a -lc -lm -lz -ldl -llog -lx264 --warn-once --dynamic-linker=/system/bin/linker $PREBUILT/lib/gcc/i686-android-linux/4.4.3/libgcc.a
}

build_one
