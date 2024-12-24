LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := RemovePackages
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_OVERRIDES_PACKAGES := \
    MatLog \
    Aperture \
    Drive \
    Gmail2 \
    Maps \
    Velvet \
    YouTube \
    AndroidAutoStub \
    talkback \
    PersonalSafety \
    Turbo \
    GoogleCameraGo
LOCAL_UNINSTALLABLE_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_SRC_FILES := /dev/null
include $(BUILD_PREBUILT)
