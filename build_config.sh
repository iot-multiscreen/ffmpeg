#!/bin/bash
NDK=/home/muxi/NDK/android-ndk-r21e
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
API=28


# 声明方法
function build_android
{
	./configure \
    --prefix=$PREFIX \
    --enable-encoders \
    --enable-decoders \
    --enable-avdevice \
    --disable-static \
    --enable-ffplay \
    --enable-network \
    --disable-doc \
    --disable-symver \
    --enable-neon \
    --enable-shared \
    --enable-gpl \
    --enable-pic \
    --enable-jni \
	--enable-debug=3 \
    --enable-pthreads \
    --enable-mediacodec \
    --enable-encoder=aac \
    --enable-encoder=gif \
	--enable-encoder=mpeg4 \
    --enable-encoder=pcm_s16le \
    --enable-encoder=png \
    --enable-encoder=srt \
    --enable-encoder=subrip \
    --enable-encoder=yuv4 \
    --enable-encoder=text \
    --enable-decoder=aac \
    --enable-decoder=aac_latm \
    --enable-decoder=mp3 \
    --enable-decoder=mpeg4_mediacodec \
    --enable-decoder=pcm_s16le \
    --enable-decoder=flac \
    --enable-decoder=flv \
    --enable-decoder=gif \
    --enable-decoder=png \
    --enable-decoder=srt \
    --enable-decoder=xsub \
    --enable-decoder=yuv4 \
    --enable-decoder=vp8_mediacodec \
    --enable-decoder=vp9_mediacodec \
    --enable-decoder=hevc_mediacodec \
    --enable-decoder=h264_mediacodec \
    --enable-decoder=mpeg4_mediacodec \
	--enable-ffmpeg \
    --enable-bsf=aac_adtstoasc \
    --enable-bsf=h264_mp4toannexb \
    --enable-bsf=hevc_mp4toannexb \
    --enable-bsf=mpeg4_unpack_bframes \
	--disable-filter=lut3d \
	--disable-iconv \
	--disable-asm \
	--disable-ffprobe \
	--cross-prefix=$CROSS_PREFIX \
	--target-os=android \
	--arch=$ARCH \
	--cpu=$CPU \
	--enable-cross-compile \
	--cc=$CC \
	--cxx=$CXX \
	--sysroot=$SYSROOT \
	--enable-small \
	--extra-cflags="-Os -fpic $ADDI_CFLAGS" \
	--extra-ldflags="$ADDI_LDFLAGS" \
	$ADDITIONAL_CONFIGURE_FLAG

	make clean
	make -j8
	make install
}

function choose_build(){
	CPU=$1
	LIBPATH=""
	echo "CPU $CPU"
	if [[ $CPU = 'armv7-a' ]];
	then
		ARCH=arm
		LIBPATH=armeabi-v7a
		CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
		CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
		CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
	elif [[ $CPU = 'armv8-a' ]];
	then
		ARCH=arm64
		LIBPATH=arm64-v8a
		CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
		CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
		CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
	elif [[ $CPU = 'x86' ]];
	then
		ARCH=x86
		LIBPATH=x86
		CC=$TOOLCHAIN/bin/i686-linux-android$API-clang
		CXX=$TOOLCHAIN/bin/i686-linux-android$API-clang++
		CROSS_PREFIX=$TOOLCHAIN/bin/i686-linux-android-
	elif [[ $CPU = 'x86_64' ]];
	then
		ARCH=x86_64
		LIBPATH=x86_64
		CC=$TOOLCHAIN/bin/x86_64-linux-android$API-clang
		CXX=$TOOLCHAIN/bin/x86_64-linux-android$API-clang++
		CROSS_PREFIX=$TOOLCHAIN/bin/x86_64-linux-android-
	else
	  echo "Input Is Error."
	fi
	
	PREFIX=$(pwd)/android/$LIBPATH
	SYSROOT=$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot
}

function copy_lib(){
	mkdir -p android/release_android/$LIBPATH
	cp -rf $PREFIX/lib android/release_android/$LIBPATH/lib
	if [[ $CPU = 'armv8-a' ]];
	then
		cp -rf $PREFIX/include android/release_android/include
	else
	  echo "do nothing."
	fi
}
choose_build $1
build_android
copy_lib

