# Android makefile for libhellodjinni shared lib

# Application.mk: http://developer.android.com/ndk/guides/application_mk.html

# APP_ABI := all
# skipping mips / mips64
APP_ABI := armeabi armeabi-v7a arm64-v8a x86 x86_64
APP_OPTIM := release
APP_PLATFORM := android-14
# GCC 4.9 Toolchain - requires NDK r10
NDK_TOOLCHAIN_VERSION = 4.9
# GNU libc++ is the only Android STL which supports C++11 features
APP_CFLAGS += -Wall
APP_CPPFLAGS += -std=c++11 -frtti -fexceptions
APP_STL := gnustl_static
APP_BUILD_SCRIPT := jni/Android.mk
APP_MODULES := libhellodjinni_jni
