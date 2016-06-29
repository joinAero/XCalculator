#!/bin/bash

if [[ -n $1 ]]; then
    prop_file=$1
else
    prop_file="$(cd "`dirname "$0"`" && pwd)/../local.properties"
fi

# Read properties
eval $(cat ${prop_file} | sed 's/<[^>]*>//g;s/\.dir=/_dir=/')

# Set default to properties
if [[ -z $ndk_dir ]]; then
    if [[ -z $ANDROID_NDK_HOME ]]; then
        ANDROID_NDK_HOME=$(dirname $(which ndk-build))
    fi
    ndk_dir=$ANDROID_NDK_HOME
fi

# exec 2>err.log
if [[ -z $djinni_dir || -z $gyp_dir || -z $ndk_dir ]]; then
    echo "Unspecified properties:" 1>&2
    [[ -z $djinni_dir ]] && echo "  djinni.dir" 1>&2
    [[ -z $gyp_dir ]] && echo "  gyp.dir" 1>&2
    [[ -z $ndk_dir ]] && echo "  ndk.dir" 1>&2
    exit 1
fi

echo "djinni_dir=$djinni_dir"
echo "gyp_dir=$gyp_dir"
echo "ndk_dir=$ndk_dir"
