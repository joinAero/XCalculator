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

create_gypi_prop() {
    local gypi="$1"; shift
    [[ -e $gypi ]] && rm -f $gypi

    exec 6>&1
    exec 1>$gypi
    echo "{"
    echo "  'variables': {"
    echo "    'DJINNI_DIR': '$djinni_dir',"
    echo "    'GYP_DIR': '$gyp_dir',"
    echo "    'NDK_DIR': '$ndk_dir',"
    echo "  },"
    echo "}"
    exec 1>&6
    exec 6>&-
}

create_gypi_prop "$out_dir/properties.gypi"
