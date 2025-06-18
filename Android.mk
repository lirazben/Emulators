# Android.mk
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE    := your-test-binary
LOCAL_SRC_FILES := main.cpp
LOCAL_LDLIBS    += -llog -lc++_shared
include $(BUILD_EXECUTABLE)