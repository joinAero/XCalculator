MD := -mkdir -p
RD := -rm -rf
RM := -rm -f

SED_PROP := "s/<[^>]*>//g;s/.*=\(.*\)/\1/"

define read_prop
	$(eval $(1) := $(shell ../tools/read_properties.sh \
		| grep -m1 $(2) | sed $(SED_PROP)))
endef

$(call read_prop,GYP_DIR,gyp_dir)
$(call read_prop,NDK_DIR,ndk_dir)


OUT_DIR ?= build
IOS_OUT ?= $(OUT_DIR)/ios

DEPS_DIR ?= deps
DEPS_DJINNI_DIR := $(DEPS_DIR)/djinni

DJINNI_OUT_DIR ?= ../generated-src


.PHONY: all
all: cpp_pro ios_pro android_pro android_pro2

.PHONY: clean
clean:
	@make ios_pro_clean
	@make android_pro_clean
	@make android_pro2_clean
	@echo "\033[1;35;47mClean others...\033[0m"
	$(RD) $(OUT_DIR)/
	$(RD) $(DEPS_DIR)/
	$(RD) $(DJINNI_OUT_DIR)/
	$(RM) ../GypAndroid.mk
	$(RM) libhellodjinni_jni.target.mk
	@# @make cpp_pro_clean

deps:
	@echo "\033[1;35;47mPrepare dependencies...\033[0m"
	@../tools/prepare_deps.sh $(DEPS_DIR)

$(DJINNI_OUT_DIR): ../hellodjinni.djinni
	@echo "\033[1;35;47mGenerate djinni interface code...\033[0m"
	@../run_djinni.sh

.PHONY: djinni
djinni: $(DJINNI_OUT_DIR)

.PHONY: cpp_pro
cpp_pro: $(DJINNI_OUT_DIR)
	@make -f Cpp.mk cpp_pro

.PHONY: cpp_pro_clean
cpp_pro_clean:
	@make -f Cpp.mk clean

$(IOS_OUT)/libhellodjinni.xcodeproj: deps $(DJINNI_OUT_DIR) libhellodjinni.gyp \
		$(DEPS_DJINNI_DIR)/support-lib/support_lib.gyp
	@echo "\033[1;35;47mGenerate libhellodjinni.xcodeproj...\033[0m"
	@$(GYP_DIR)/gyp --depth=. -f xcode -DOS=ios \
		--generator-output $(IOS_OUT) \
		-DDJINNI_DIR=$(DEPS_DJINNI_DIR) \
		-I$(DEPS_DJINNI_DIR)/common.gypi \
		libhellodjinni.gyp

.PHONY: ios_pro
ios_pro: $(IOS_OUT)/libhellodjinni.xcodeproj
	@echo "\033[1;35;47mBuild ios project...\033[0m"
	xcodebuild -workspace ios/HelloDjinni.xcworkspace \
		-scheme HelloDjinni -configuration 'Debug' -sdk iphonesimulator

.PHONY: ios_pro_clean
ios_pro_clean:
	@echo "\033[1;35;47mClean ios project...\033[0m"
	@-xcodebuild -workspace ios/HelloDjinni.xcworkspace \
		-scheme HelloDjinni -configuration 'Debug' -sdk iphonesimulator clean

../GypAndroid.mk: deps $(DJINNI_OUT_DIR) libhellodjinni.gyp \
		$(DEPS_DJINNI_DIR)/support-lib/support_lib.gyp
	@echo "\033[1;35;47mGenerate GypAndroid.mk...\033[0m"
	@make gyp_android
	@cd .. && ANDROID_BUILD_TOP=$(NDK_DIR) \
		$(GYP_DIR)/gyp --depth=. -f android -DOS=android \
		-DDJINNI_DIR=$(DEPS_DJINNI_DIR) \
		-Iproject/$(DEPS_DJINNI_DIR)/common.gypi \
		project/libhellodjinni.gyp \
		--root-target=libhellodjinni_jni
	@make gyp_master

.PHONY: android_pro
android_pro: ../GypAndroid.mk
	@echo "\033[1;35;47mBuild android project (HelloDjinni)...\033[0m"
	cd android/HelloDjinni/ && ./gradlew app:assembleDebug
	@echo "\033[32mApks produced at:\033[0m"
	@python $(DEPS_DJINNI_DIR)/example/glob.py \
		android/HelloDjinni/app/build/outputs/apk/ '*.apk'

.PHONY: android_pro_clean
android_pro_clean: ../GypAndroid.mk
	@echo "\033[1;35;47mClean android project (HelloDjinni)...\033[0m"
	@ndk-build -C android/HelloDjinni/app-core clean
	@-cd android/HelloDjinni/ && ./gradlew clean

.PHONY: android_pro2
android_pro2: deps djinni libhellodjinni.gyp \
		$(DEPS_DJINNI_DIR)/support-lib/support_lib.gyp
	@echo "\033[1;35;47mBuild android project (HelloDjinni2)...\033[0m"
	cd android/HelloDjinni2/ && ./gradlew app:assembleDebug
	@echo "\033[32mApks produced at:\033[0m"
	@python $(DEPS_DJINNI_DIR)/example/glob.py \
		android/HelloDjinni2/app/build/outputs/apk/ '*.apk'

.PHONY: android_pro2_clean
android_pro2_clean:
	@echo "\033[1;35;47mClean android project (HelloDjinni2)...\033[0m"
	@-cd android/HelloDjinni2/ && ./gradlew clean

.PHONY: gyp_status
gyp_status:
	@cd $(GYP_DIR) && git status

.PHONY: gyp_master
gyp_master:
	@echo "\033[1;35;47mCheckout gyp to master...\033[0m"
	@cd $(GYP_DIR) && git checkout master

.PHONY: gyp_android
gyp_android:
	@echo "\033[1;35;47mCheckout gyp to android generator...\033[0m"
	@cd $(GYP_DIR) && git checkout -q 0bb67471bca068996e15b56738fa4824dfa19de0

.PHONY: test_vars
test_vars:
	@echo "\033[1;35;47mPrint variables...\033[0m"
	@echo GYP_DIR=$(GYP_DIR)
	@echo NDK_DIR=$(NDK_DIR)
	@echo OUT_DIR=$(OUT_DIR)
	@echo IOS_OUT=$(IOS_OUT)
	@echo DEPS_DIR=$(DEPS_DIR)
	@echo DEPS_DJINNI_DIR=$(DEPS_DJINNI_DIR)
