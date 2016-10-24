LOCAL_PATH := $(call my-dir)

# camera

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
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

#ril socket
include $(CLEAR_VARS)

LOCAL_SRC_FILES := rild_socket.c

LOCAL_MODULE := rild_socket
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

# thermal

include $(CLEAR_VARS)

LOCAL_SRC_FILES := thermal.c

LOCAL_MODULE := libshims_thermal
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)
