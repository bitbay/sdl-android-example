CONFIG ?= Makefile.local
-include $(CONFIG)

HOST_OS     ?= $(shell uname | sed -e s/_.*// | tr '[:upper:]' '[:lower:]')
TARGET_OS   ?= $(HOST_OS)
TARGET_ARCH ?= $(shell uname -m | sed -e s/i.86/i386/)

ifneq ($(findstring $(HOST_OS),sunos darwin),)
  TARGET_ARCH ?= $(shell uname -p | sed -e s/i.86/i386/)
endif

MODE        ?= debug

ANDROID_PROJECT=android-project
ifeq ($(DEBUG),)
ANT_TARGET:=release
ANT_INSTALL_TARGET:=installr
else
ANT_TARGET:=debug
ANT_INSTALL_TARGET:=installd
endif
ifeq ($(Q),)
NDK_VERBOSE:="V=1"
else
NDK_VERBOSE:=
endif

.PHONY: android
android: android-update-project android-copy-assets android-uninstall
	@echo "===> NDK [native build]"
	$(Q)cd $(ANDROID_PROJECT) && ndk-build $(NDK_VERBOSE)
	@echo "===> ANT [java build]"
	$(Q)cd $(ANDROID_PROJECT) && ant $(ANT_TARGET)
	$(Q)cd $(ANDROID_PROJECT) && ant $(ANT_INSTALL_TARGET)

.PHONY: clean-android
clean-android:
	@echo "===> ANDROID [clean project]"
	$(Q)rm -rf $(ANDROID_PROJECT)/assets
	$(Q)rm -rf $(ANDROID_PROJECT)/bin
	$(Q)rm -rf $(ANDROID_PROJECT)/obj
	$(Q)rm -rf $(ANDROID_PROJECT)/gen
	$(Q)rm -rf $(ANDROID_PROJECT)/local.properties

android-update-project: $(ANDROID_PROJECT)/local.properties

$(ANDROID_PROJECT)/local.properties:
	@echo "===> ANDROID [update project]"
	$(Q)cd $(ANDROID_PROJECT); SDK=`android  list sdk | grep "SDK Platform Android 2.3.3" | awk -F'-' ' { print $$1 }'`; [ -n "$$SDK" ] && android update sdk -u -s -t $$SDK || echo
	$(Q)cd $(ANDROID_PROJECT) && android update project -p . -t android-10

.PHONY: android-copy-assets
android-copy-assets:
	@echo "===> CP [copy assets]"
	$(Q)mkdir -p $(ANDROID_PROJECT)/assets
	$(Q)cp -r data $(ANDROID_PROJECT)/assets

android-backtrace:
	adb logcat | ndk-stack -sym $(ANDROID_PROJECT)/obj/local/armeabi

android-uninstall:
	#$(Q)cd $(ANDROID_PROJECT) && ant uninstall
