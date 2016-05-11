#!/bin/bash
set -e
shopt -s nullglob

base_dir=$(cd "`dirname "$0"`" && pwd)

# Read profile yaml
eval $($base_dir/tools/read_yaml.sh $base_dir/run_profile.yaml)


# Set default values
[ -n "$out_dir" ] || out_dir="generated-src"

[ -n "$java_out" ] || java_out="java"
[ -n "$cpp_out" ] || cpp_out="cpp"
[ -n "$jni_out" ] || jni_out="jni"
[ -n "$objc_out" ] || objc_out="objc"
[ -n "$objcpp_out" ] || objcpp_out="objc"

out_dir=$base_dir/$out_dir


# Clean output folder
clean() {
    if [ -e "$out_dir" ]; then
        echo "Deleting \"$out_dir\"..."
        rm -r "$out_dir"
    fi
}


if [ $# -eq 0 ]; then
    # Normal build.
    true
elif [ $# -eq 1 ]; then
    cmd="$1"; shift
    if [ "$cmd" != "clean" ]; then
        echo "Unexpected argument: \"$cmd\"." 1>&2
        exit 1
    fi
    clean
    exit
fi


# Generate djinni code
generate() {
    # "$djinni_dir/src/run-assume-built" --help

    cmd+=("$djinni_dir/src/run-assume-built" \
    --java-out "$out_dir/$java_out" \
    --java-nullable-annotation "javax.annotation.CheckForNull" \
    --java-nonnull-annotation "javax.annotation.Nonnull" \
    --ident-java-field mFooBar \
    \
    --cpp-out "$out_dir/$cpp_out" \
    --cpp-ext "cc" \
    --ident-cpp-enum-type foo_bar \
    \
    --jni-out "$out_dir/$jni_out" \
    --ident-jni-class NativeFooBar \
    --ident-jni-file NativeFooBar \
    \
    --objc-out "$out_dir/$objc_out" \
    --objcpp-out "$out_dir/$objcpp_out" \
    \
    --idl "$base_dir/$in_idl")

    # Extra options
    [ -n "$java_package" ] && cmd+=(--java-package $java_package)
    [ -n "$cpp_namespace" ] && cmd+=(--cpp-namespace $cpp_namespace)
    [ -n "$objc_type_prefix" ] && cmd+=(--objc-type-prefix $objc_type_prefix)

    # echo "${cmd[*]}"

    # Run command
    echo "$(${cmd[*]})"
}


mirror() {
    local prefix="$1"; shift
    local src="$1"; shift
    local dest="$1"; shift
    mkdir -p "$dest"
    rsync -a --delete --checksum --itemize-changes "$src"/ "$dest" | grep -v '^\.' | sed "s/^/[$prefix]/"
}


# echo -e "\033[1;35mClean\033[0m"
clean
# echo -e "\033[1;35mGenerate\033[0m"
generate

if [ -n "$java_package" ]; then
    echo "Moving Java files..."
    java_src="$out_dir/$java_out"
    java_temp="${java_src}_temp"
    java_dest="$java_src/$(echo "$java_package" | sed "s/\./\//g")"
    mv -f "$java_src" "$java_temp"
    mirror "java" "$java_temp" "$java_dest"
    rm -rf "$java_temp"
fi

date > "$out_dir/gen.stamp"
