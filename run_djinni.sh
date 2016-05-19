#!/bin/bash
set -e
shopt -s nullglob

while getopts ":cp:d:i:o:" opt; do
    case "$opt" in
        c) opt_clean=1 ;;
        p) opt_profile="$OPTARG" ;;
        d) opt_djinni_dir="$OPTARG" ;;
        i) opt_in_idl="$OPTARG" ;;
        o) opt_out_dir="$OPTARG" ;;
        ?) echo "Usage: $0 [-c] [-p profile.yaml] [-d djinni_dir] [-i in_idl] [-o out_dir]"
           exit 2 ;;
    esac
done


base_dir=$(cd "`dirname "$0"`" && pwd)

profile_yaml="$opt_profile"
[ -n "$profile_yaml" ] || profile_yaml="$base_dir/run_profile.yaml"

# Read profile yaml
eval $($base_dir/tools/read_yaml.sh $profile_yaml)

# Set default values

if [ -n "$opt_djinni_dir" ]; then
    djinni_dir="$opt_djinni_dir"
elif [ -z "$djinni_dir" ]; then
    echo "Profile option required: djinni_dir" 1>&2
    exit 2
fi

djinni_run="$djinni_dir/src/run-assume-built"
if [ ! -x "$djinni_run" ]; then
    echo "Executable djinni file not found: $djinni_run" 1>&2
    exit 2
fi

if [ -n "$opt_in_idl" ]; then
    in_idl="$opt_in_idl"
elif [ -n "$in_idl" ]; then
    in_idl="$base_dir/$in_idl"
else
    echo "Profile option required: in_idl" 1>&2
    exit 2
fi

if [ -n "$opt_out_dir" ]; then
    out_dir="$opt_out_dir"
elif [ -n "$out_dir" ]; then
    out_dir="$base_dir/$out_dir"
else
    out_dir="$base_dir/generated-src"
fi

[ -n "$java_out" ] || java_out="java"
[ -n "$cpp_out" ] || cpp_out="cpp"
[ -n "$jni_out" ] || jni_out="jni"
[ -n "$objc_out" ] || objc_out="objc"
[ -n "$objcpp_out" ] || objcpp_out="objc"


# Clean output folder
clean() {
    if [ -e "$out_dir" ]; then
        echo "Deleting \"$out_dir\"..."
        rm -r "$out_dir"
    fi
}


if [ ! -z $opt_clean ]; then
    echo "Cleaning..."
    clean
    exit
fi


# Generate djinni code
generate() {
    cmd+=("$djinni_run" \
    --java-out "$out_dir/$java_out" \
    --java-nullable-annotation "javax.annotation.CheckForNull" \
    --java-nonnull-annotation "javax.annotation.Nonnull" \
    --ident-java-field mFooBar \
    \
    --cpp-out "$out_dir/$cpp_out" \
    --ident-cpp-enum-type foo_bar \
    \
    --jni-out "$out_dir/$jni_out" \
    --ident-jni-class NativeFooBar \
    --ident-jni-file NativeFooBar \
    \
    --objc-out "$out_dir/$objc_out" \
    --objcpp-out "$out_dir/$objcpp_out" \
    \
    --idl "$in_idl")

    # Extra options
    [ -n "$java_package" ] && cmd+=(--java-package $java_package)
    [ -n "$cpp_ext" ] && cmd+=(--cpp-ext $cpp_ext)
    [ -n "$cpp_namespace" ] && cmd+=(--cpp-namespace $cpp_namespace)
    [ -n "$objc_type_prefix" ] && cmd+=(--objc-type-prefix $objc_type_prefix)
    [ -n "$yaml_out" ] && cmd+=(--yaml-out $yaml_out)
    [ -n "$yaml_out_file" ] && cmd+=(--yaml-out-file $yaml_out_file)
    [ -n "$yaml_prefix" ] && cmd+=(--yaml-prefix $yaml_prefix)

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
