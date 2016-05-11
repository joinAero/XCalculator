#!/bin/bash
set -e
shopt -s nullglob

base_dir=$(cd "`dirname "$0"`" && pwd)

# Read local properties
eval $(cat $base_dir/local.properties | sed 's/<[^>]*>//g' | sed 's/\./_/g')
if [[ -z $djinni_dir ]]; then
    echo "Unspecified djinni.dir in local.properties" 1>&2
    exit 1
fi


out_dir="$base_dir/generated-src"

cpp_out="$out_dir/cpp"
jni_out="$out_dir/jni"
objc_out="$out_dir/objc"
java_out="$out_dir/java/cc/eevee/hellodjinni"

java_package="cc.eevee.hellodjinni"
cpp_namespace="hellodjinni"
objc_type_prefix="HD"
djinni_file="$base_dir/hellodjinni.djinni"


[[ -e $out_dir ]] && rm -rf $out_dir

$djinni_dir/src/run-assume-built \
    --java-out $java_out \
    --java-package $java_package \
    --ident-java-field mFooBar \
    \
    --cpp-out $cpp_out \
    --cpp-namespace $cpp_namespace \
    \
    --jni-out $jni_out \
    --ident-jni-class NativeFooBar \
    --ident-jni-file NativeFooBar \
    \
    --objc-out $objc_out \
    --objcpp-out $objc_out \
    --objc-type-prefix $objc_type_prefix \
    \
    --idl $djinni_file
