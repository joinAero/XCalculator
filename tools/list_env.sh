#!/bin/bash

ecol() {
    local text="$1"; shift
    if [ -z "$text" ]; then
        echo; return
    fi

    local code="$1"; shift
    [ -n "$code" ] || code="1;35"

    echo -e "\033[${code}m${text}\033[0m"
}

ecol "# OS"
echo `sw_vers`
echo

ecol "# XCode"
echo `xcodebuild -version`
echo

ecol "# XCode 命令行工具"
echo "# xcode-select --install"
echo `xcode-select -v`
echo

ecol "# Java"
echo `java -version`
# echo

ecol "# Android Studio"
echo "# Android Studio > About Android Studio"
echo "# Android Studio > Appearance & Behavior > System Settings > Updates"
echo

ecol "# Android NDK"
echo `ndk-build --version`
