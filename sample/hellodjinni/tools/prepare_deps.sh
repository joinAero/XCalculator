#!/bin/bash

while getopts "o:p:" opt; do
  case $opt in
    o) out_dir=$OPTARG ;;
    p) prop_file=$OPTARG ;;
  esac
done

base_dir=$(cd "`dirname "$0"`" && pwd)

[ -n "$out_dir" ] || out_dir=.
[ -n "$prop_file" ] || prop_file="$base_dir/../local.properties"

eval $($base_dir/read_properties.sh $prop_file)

copy() {
    local src="$1"; shift
    local dest="$1"; shift
    if [[ -d $dest ]]; then
        mkdir -p "$dest"
    else
        mkdir -p `dirname "$dest"`
    fi
    # http://serverfault.com/questions/153875/
    # how-to-let-cp-command-dont-fire-an-error-when-source-file-does-not-exist
    cp -R -n "$src" "$dest" 2>/dev/null || :
}

deps_dir=$out_dir/deps
deps_djinni_dir=$deps_dir/djinni

echo "Copying djinni..."
copy "$djinni_dir/support-lib" "$deps_djinni_dir/support-lib"
copy "$djinni_dir/common.gypi" "$deps_djinni_dir/common.gypi"
copy "$djinni_dir/example/glob.py" "$deps_djinni_dir/example/glob.py"
