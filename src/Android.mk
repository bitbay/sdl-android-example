LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE      := main

SDL_PATH := ../SDL
SDL_IMAGE_PATH := ../SDL_image
SDL_MIXER_PATH := ../SDL_mixer
SDL_NET_PATH := ../SDL_net

NAME := myawesomegame

LOCAL_SRC_FILES := \
	$(subst jni/src/,,$(wildcard jni/src/*.cpp)) \
	\
	libs/SDL/src/main/android/SDL_android_main.c

LOCAL_CFLAGS :=

LOCAL_C_INCLUDES  :=
LOCAL_C_INCLUDES  += $(LOCAL_PATH)
LOCAL_C_INCLUDES  += $(LOCAL_PATH)/libs
LOCAL_C_INCLUDES  += $(LOCAL_PATH)/libs/SDL/include
LOCAL_C_INCLUDES  += $(LOCAL_PATH)/libs/SDL_image
LOCAL_C_INCLUDES  += $(LOCAL_PATH)/libs/SDL_mixer
LOCAL_C_INCLUDES  += $(LOCAL_PATH)/libs/SDL_net

LOCAL_SHARED_LIBRARIES := SDL2 SDL2_image SDL2_mixer SDL2_net
LOCAL_LDLIBS           := -lGLESv2 -llog -lz -lm

include $(BUILD_SHARED_LIBRARY)
