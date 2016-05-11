
# Hello Djinni

The sample about using [Djinni](https://github.com/dropbox/djinni).

## Folder Structure

```
hellodjinni/
├─project/
│  ├─android/
│  │  ├─HelloDjinni/                # Android Project with GYP & ndk-build
│  │  └─HelloDjinni2/               # Android Project with Experimental Plugin
│  ├─cpp/
│  │  └─HelloDjinni/                # Cpp Test Project
│  └─ios/
│      ├─HelloDjinni/
│      └─HelloDjinni.xcworkspace/   # iOS Project Workspace
├─src/
│  └─cpp/                           # Cpp Interface Impls
└─tools/                            # Helper Scripts
```

## Build & Clean

**Build all:**

```
$ cd sample/hellodjinni/project/
$ make
```

**Clean all:**

```
$ make clean
```
