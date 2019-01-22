LOCAL_PATH := $(call my-dir)

# liblog
include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
    moto_log.c
LOCAL_MODULE := libshim_log
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

# libmdmcutback
include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
    moto_mdmcutback.c
LOCAL_MODULE := libshim_mdmcutback
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

# libqc-opt
include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
    icu53.c
LOCAL_SHARED_LIBRARIES := libicuuc libicui18n
LOCAL_MODULE := libshim_qcopt
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

# libril
include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
    moto_ril.c
LOCAL_SHARED_LIBRARIES := libbinder
LOCAL_MODULE := libshim_ril
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := thermal.c
LOCAL_MODULE := libshims_thermal
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := GraphicBuffer.cpp
LOCAL_MODULE := libshims_graphicbuffer
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
    sensorlistener/ISensorServer.cpp \
    sensorlistener/SensorManager.cpp
LOCAL_MODULE := libshim_sensorlistener
LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES := \
    libnativeloader \
    libbinder \
    libcutils \
    libEGL \
    libGLESv2 \
    libsync \
    libui \
    libutils \
    liblog \
    libbase \
    libsensor
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := frameproc.cpp
LOCAL_MODULE := libframeproc_shim
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)
