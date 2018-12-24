#
# Copyright (C) 2014 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# inherit from the proprietary version
-include vendor/motorola/msm8960dt-common/BoardConfigVendor.mk

LOCAL_PATH := device/motorola/msm8960dt-common

BOARD_VENDOR := motorola-qcom

TARGET_SPECIFIC_HEADER_PATH := $(LOCAL_PATH)/include

# Platform
TARGET_BOARD_PLATFORM       := msm8960
TARGET_BOARD_PLATFORM_GPU   := qcom-adreno320

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME    := MSM8960
TARGET_NO_BOOTLOADER            := true

# Architecture
TARGET_ARCH                             := arm
TARGET_ARCH_VARIANT                     := armv7-a-neon
TARGET_CPU_ABI                          := armeabi-v7a
TARGET_CPU_ABI2                         := armeabi
TARGET_CPU_SMP 							:= true
TARGET_CPU_VARIANT                      := krait
TARGET_USE_QCOM_BIONIC_OPTIMIZATION     := true
TARGET_GLOBAL_CFLAGS 					+= -mfpu=neon -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS 					+= -mfpu=neon -mfloat-abi=softfp

# Kernel
BOARD_CUSTOM_BOOTIMG_MK    := $(LOCAL_PATH)/mkbootimg.mk
BOARD_KERNEL_LZ4C_DT 	   := true
LZMA_RAMDISK_TARGETS 	   := recovery
BOARD_KERNEL_CMDLINE       := console=ttyHSL0,115200,n8 androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 maxcpus=2 androidboot.write_protect=0
#BOARD_KERNEL_CMDLINE       += androidboot.selinux=permissive
BOARD_KERNEL_BASE          := 0x80200000
BOARD_KERNEL_PAGESIZE      := 2048
BOARD_KERNEL_SEPARATED_DT  := true
BOARD_MKBOOTIMG_ARGS       := --ramdisk_offset 0x02200000
TARGET_KERNEL_SOURCE       := kernel/motorola/ghost
TARGET_KERNEL_CONFIG       := msm8960dt_mmi_defconfig

# Audio
BOARD_USES_ALSA_AUDIO               := true
USE_CUSTOM_AUDIO_POLICY             := 1
BOARD_USES_FLUENCE_INCALL           := true
BOARD_USES_SEPERATED_AUDIO_INPUT    := true
BOARD_USES_SEPERATED_VOICE_SPEAKER  := true
AUDIO_USE_LL_AS_PRIMARY_OUTPUT 	    := true
QCOM_MULTI_VOICE_SESSION_ENABLED    := true

# Bluetooth
BOARD_HAVE_BLUETOOTH        := true
BOARD_HAVE_BLUETOOTH_QCOM   := true
BLUETOOTH_HCI_USE_MCT       := true

# Camera
TARGET_HAS_LEGACY_CAMERA_HAL1 	:= true
USE_DEVICE_SPECIFIC_CAMERA 		:= true
TARGET_NEEDS_PLATFORM_TEXT_RELOCATIONS := true
BOARD_GLOBAL_CFLAGS += -DCAMERA_VENDOR_L_COMPAT

# Legacy Hacks
TARGET_NEEDS_GCC_LIBC := true
BOARD_GLOBAL_CFLAGS += -DDECAY_TIME_DEFAULT=0

MALLOC_SVELTE 					:= true

# Display
NUM_FRAMEBUFFER_SURFACE_BUFFERS     := 3
TARGET_DISPLAY_USE_RETIRE_FENCE     := true
TARGET_USES_C2D_COMPOSITION         := true
TARGET_USES_ION                     := true
USE_OPENGL_RENDERER                 := true

# Flags
BOARD_USES_LEGACY_MMAP := true

# Power HAL
TARGET_POWERHAL_VARIANT := qcom

# Qualcomm support
BOARD_USES_QCOM_HARDWARE := true

# Recovery
TARGET_RECOVERY_FSTAB                   := $(LOCAL_PATH)/rootdir/etc/fstab.qcom
TARGET_USERIMAGES_USE_EXT4              := true
TARGET_USERIMAGES_USE_F2FS              := true
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE       := ext4
TARGET_RECOVERY_DENSITY                 := xhdpi

# RIL
BOARD_RIL_CLASS := ../../../$(LOCAL_PATH)/ril/

BOARD_SECCOMP_POLICY := device/motorola/msm8960dt-common/seccomp

# SELinux
-include device/qcom/sepolicy/sepolicy.mk

BOARD_SEPOLICY_DIRS += \
    $(LOCAL_PATH)/sepolicy

# Wifi
BOARD_HAS_QCOM_WLAN                 := true
BOARD_HAS_QCOM_WLAN_SDK             := true
BOARD_HOSTAPD_DRIVER                := NL80211
BOARD_HOSTAPD_PRIVATE_LIB           := lib_driver_cmd_qcwcn
BOARD_WLAN_DEVICE                   := qcwcn
BOARD_WPA_SUPPLICANT_DRIVER         := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB    := lib_driver_cmd_qcwcn
WIFI_DRIVER_FW_PATH_AP              := "ap"
WIFI_DRIVER_FW_PATH_STA             := "sta"
WPA_SUPPLICANT_VERSION              := VER_0_8_X

#TWRP
# Recovery: TWRP support
ifeq ($(WITH_TWRP),true)
-include $(PLATFORM_PATH)/twrp.mk
endif
BOARD_GLOBAL_CFLAGS += -DNO_SECURE_DISCARD
HAVE_SELINUX 						:= true
BOARD_HAS_NO_REAL_SDCARD            := true
RECOVERY_SDCARD_ON_DATA             := true
TARGET_RECOVERY_PIXEL_FORMAT        := "RGB_565"
TW_EXTERNAL_STORAGE_PATH            := "/usb-otg"
TW_EXTERNAL_STORAGE_MOUNT_POINT     := "usb-otg"
DEVICE_RESOLUTION                   := 720x1280
BOARD_SUPPRESS_SECURE_ERASE         := true
TW_INCLUDE_CRYPTO 			    	:= true
TW_FLASH_FROM_STORAGE 				:= true
TARGET_HW_DISK_ENCRYPTION 		    := true
TW_TARGET_USES_QCOM_BSP             := true
TW_DEFAULT_EXTERNAL_STORAGE         := true
TW_INCLUDE_NTFS_3G                  := true
TW_NO_SCREEN_BLANK                  := true
TW_NO_USB_STORAGE                   := true
TW_INCLUDE_FUSE_EXFAT 				:= true
#TW_THEME                            := portrait_hdpi
TW_THEME                            := portrait_hdpi
TW_BRIGHTNESS_PATH 				    := /sys/class/backlight/lcd-backlight/brightness
TARGET_USE_CUSTOM_LUN_FILE_PATH     := /sys/devices/platform/msm_hsusb/gadget/lun0/file
# Debug flags
TWRP_INCLUDE_LOGCAT					:= true
TW_MAX_BRIGHTNESS 					:= 126
