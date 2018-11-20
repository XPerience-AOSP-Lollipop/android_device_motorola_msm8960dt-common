LOCAL_PATH := $(call my-dir)

# camera

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    GraphicBuffer.cpp \
    gui/SensorManager.cpp

LOCAL_SHARED_LIBRARIES := libutils libgui liblog libbinder libui
LOCAL_MODULE := libshim_camera
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

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

# libshims_cameraservice
include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
    libcameraservice/CameraFlashlight.cpp \
    libcameraservice/api1/CameraClient.cpp
LOCAL_C_INCLUDES += \
    frameworks/native/include/media/openmax
LOCAL_SHARED_LIBRARIES:= \
    libui \
    liblog \
    libutils \
    libbinder \
    libcutils \
    libmedia \
    libmediautils \
    libcamera_client \
    libgui \
    libhardware \
    libsync \
    libcamera_metadata \
    libjpeg \
    libmemunreachable \
    libcameraservice

LOCAL_MODULE := libshims_cameraservice
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
    bionic/bionic_time_conversions.cpp \
    bionic/pthread_cond.cpp
LOCAL_SHARED_LIBRARIES := libc
LOCAL_MODULE := libshim_bionic
LOCAL_CLANG := false
LOCAL_CXX_STL := none
LOCAL_SANITIZE := never
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
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
    libgui

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := camera_server.cpp
LOCAL_MODULE := libcameraserver_shim
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := frameproc.cpp
LOCAL_MODULE := libframeproc_shim
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)
