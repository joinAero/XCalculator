{
  "targets": [
    {
      "target_name": "libhellodjinni_jni",
      "type": "shared_library",
      "dependencies": [
        "<(DJINNI_DIR)/support-lib/support_lib.gyp:djinni_jni",
      ],
      "ldflags": [ "-llog", "-Wl,--build-id,--gc-sections,--exclude-libs,ALL" ],
      "sources": [
        "<(DJINNI_DIR)/support-lib/jni/djinni_main.cpp",
        "<!@(python <(DJINNI_DIR)/example/glob.py ../generated-src/jni '*.cpp')",
        "<!@(python <(DJINNI_DIR)/example/glob.py ../generated-src/cpp '*.cpp')",
        "<!@(python <(DJINNI_DIR)/example/glob.py ../src '*.cpp')",
      ],
      "include_dirs": [
        "../generated-src/jni",
        "../generated-src/cpp",
        "../src/cpp",
      ],
    },
    {
      "target_name": "libhellodjinni_objc",
      "type": "static_library",
      "dependencies": [
        "<(DJINNI_DIR)/support-lib/support_lib.gyp:djinni_objc",
      ],
      "sources": [
        "<!@(python <(DJINNI_DIR)/example/glob.py ../generated-src/objc '*.cpp' '*.mm' '*.m')",
        "<!@(python <(DJINNI_DIR)/example/glob.py ../generated-src/cpp  '*.cpp')",
        "<!@(python <(DJINNI_DIR)/example/glob.py ../src '*.cpp')",
      ],
      "include_dirs": [
        "../generated-src/objc",
        "../generated-src/cpp",
        "../src/cpp",
      ],
    },
  ],
}
