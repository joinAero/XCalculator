
# XCalculator

Easy Calculator on iOS and Android - An example of [Djinni](https://github.com/dropbox/djinni)

---

# [sample/hellodjinni](https://github.com/joinAero/XCalculator/tree/master/sample/hellodjinni)

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

## Reference

* [使用 Djinni 开发 Android, iOS 共享库](http://eevee.cc/2016/05/06/using-djinni/)
