#!/bin/bash

base_dir=$(cd "`dirname "$0"`" && pwd)

root_dir=$(dirname "$base_dir")
out_dir=$base_dir/build

if [ $# -eq 0 ]; then
    # Normal build.
    true
elif [ $# -eq 1 ]; then
    cmd="$1"; shift
    if [ "$cmd" != "clean" ]; then
        echo "Unexpected argument: \"$cmd\"." 1>&2
        exit 1
    fi
    rm -rf $base_dir/deps/
    rm -rf $base_dir/build/
    rm -rf $base_dir/libhellodjinni.xcodeproj/
    rm -f $base_dir/libhellodjinni_jni.target.mk
    rm -f $base_dir/../GypAndroid.mk
    rm -rf $base_dir/../generated-src/
    exit
fi

# read properties
eval $($root_dir/tools/read_properties.sh)

deps_djinni_dir=$base_dir/deps/djinni
deps_djinni_relative_dir=$(python $root_dir/tools/relpath.py \
    $deps_djinni_dir $base_dir)

# gyp attentions:
# 1) `sources` in gyp file must be relative paths, however absolute paths
# beginning with `/` are incorrect in XCode project.
# 2) When generate android by gyp, the work dir which run command must contains
# all sources directly. Otherwise, it will report error as following:
#     AssertionError: Path %s attempts to escape from gyp path %s !)

# ios
build_ios() {
    $gyp_dir/gyp --depth=. -f xcode -DOS=ios \
        --generator-output $out_dir/ios \
        -DDJINNI_DIR=$deps_djinni_relative_dir \
        -I$deps_djinni_dir/common.gypi \
        $base_dir/libhellodjinni.gyp
    # deps/gyp/gyp --depth=. -f xcode -DOS=ios
    #     --generator-output ./build_ios
    #     -Icommon.gypi
    #     example/libtextsort.gyp
}

# android
build_android() {
    export ANDROID_BUILD_TOP=$ndk_dir
    $gyp_dir/gyp --depth=. -f android -DOS=android \
        -DDJINNI_DIR=$deps_djinni_relative_dir \
        -I$deps_djinni_dir/common.gypi \
        $base_dir/libhellodjinni.gyp \
        --root-target=libhellodjinni_jni
    # ANDROID_BUILD_TOP=$(ANDROID_NDK_HOME)
    # deps/gyp/gyp --depth=. -f android -DOS=android
    # -Icommon.gypi
    # example/libtextsort.gyp
    # --root-target=libtextsort_jni
}

# generate
[[ -e "$root_dir/generated-src" ]] || $root_dir/run_djinni.sh
# prepare
$root_dir/tools/prepare_deps.sh -o $base_dir

# build ios
echo "Building ios..."
build_ios

# build android
echo "Building android..."
cd $root_dir && build_android && cd $base_dir
