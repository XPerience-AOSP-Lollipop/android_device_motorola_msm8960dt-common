#
# Copyright (C) 2014 The CyanogenMod Project
# Copyright (C) 2016 The XPerience Project
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
TARGET_BOARD_PLATFORM 	  := msm8960
TARGET_BOARD_PLATFORM_GPU := qcom-adreno320

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8960
TARGET_NO_BOOTLOADER 	     := true

# Architecture
TARGET_ARCH 			    := arm
TARGET_ARCH_VARIANT 		    := armv7-a-neon
TARGET_CPU_ABI 			    := armeabi-v7a
TARGET_CPU_ABI2			    := armeabi
TARGET_CPU_VARIANT		    := krait
TARGET_USE_QCOM_BIONIC_OPTIMIZATION := true

#Custom flags
TARGET_GLOBAL_CFLAGS 		+= -mfpu=neon-vfpv4 -mfloat-abi=hard
TARGET_GLOBAL_CPPFLAGS 		+= -mfpu=neon-vfpv4 -mfloat-abi=hard

# Kernel
BOARD_CUSTOM_BOOTIMG_MK 	   := $(LOCAL_PATH)/mkbootimg.mk
BOARD_KERNEL_CMDLINE 		   := console=ttyHSL0,115200,n8 androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 androidboot.write_protect=0 androidboot.selinux=permissive
BOARD_KERNEL_BASE 		   := 0x80200000
BOARD_KERNEL_PAGESIZE 		   := 2048
BOARD_KERNEL_SEPARATED_DT	   := true
BOARD_MKBOOTIMG_ARGS 		   := --ramdisk_offset 0x02200000
TARGET_KERNEL_SOURCE 		   := kernel/motorola/ghost
TARGET_KERNEL_CONFIG 		   := msm8960dt_mmi_defconfig
TARGET_KERNEL_CROSS_COMPILE_PREFIX := arm-linux-androideabi-

# ANT+
#BOARD_ANT_WIRELESS_DEVICE := "qualcomm-smd"

WLAN_MODULES:
	mkdir -p $(KERNEL_MODULES_OUT)/prima
	mv $(KERNEL_MODULES_OUT)/wlan.ko $(KERNEL_MODULES_OUT)/prima/prima_wlan.ko
	ln -sf /system/lib/modules/prima/prima_wlan.ko $(TARGET_OUT)/lib/modules/wlan.ko

TARGET_KERNEL_MODULES += WLAN_MODULES

# Audio
BOARD_USES_ALSA_AUDIO 		    := true
#BOARD_USES_LEGACY_ALSA_AUDIO 	    := true
#AUDIO_USE_LL_AS_PRIMARY_OUTPUT 	    := true
USE_CUSTOM_AUDIO_POLICY		    := 1
#USE_LEGACY_AUDIO_POLICY := true

# Bluetooth
#BOARD_HAVE_BLUETOOTH 	  := true
#BOARD_HAVE_BLUETOOTH_QCOM := true
#BLUETOOTH_HCI_USE_MCT 	  := true

# Camera
USE_DEVICE_SPECIFIC_CAMERA := true
TARGET_NEEDS_TEXT_RELOCATIONS := true

# Include path
TARGET_SPECIFIC_HEADER_PATH := $(PLATFORM_PATH)/include

# Display
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_DISPLAY_USE_RETIRE_FENCE := true
TARGET_USES_C2D_COMPOSITION 	:= true
TARGET_USES_ION 		:= true
USE_OPENGL_RENDERER 		:= true

# Flags
BOARD_USES_LEGACY_MMAP := true

# Power HAL
TARGET_POWERHAL_VARIANT := qcom

# Qualcomm support
BOARD_USES_QCOM_HARDWARE := true

# Recovery
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/rootdir/etc/fstab.qcom
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_RECOVERY_DENSITY := xhdpi
TARGET_NOT_USE_GZIP_RECOVERY_RAMDISK := true

# Properties
TARGET_SYSTEM_PROP += device/motorola/msm8960dt-common/system.prop

# RIL
BOARD_RIL_CLASS := ../../../$(LOCAL_PATH)/ril/

# SELinux
-include device/qcom/sepolicy/sepolicy.mk

BOARD_SEPOLICY_DIRS += \
    $(LOCAL_PATH)/sepolicy

# Wifi
BOARD_HAS_QCOM_WLAN 		 := true
BOARD_HAS_QCOM_WLAN_SDK 	 := true
BOARD_WLAN_DEVICE 		 := qcwcn
BOARD_HOSTAPD_DRIVER 		 := NL80211
BOARD_HOSTAPD_PRIVATE_LIB	 := lib_driver_cmd_qcwcn
BOARD_WPA_SUPPLICANT_DRIVER 	 := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_qcwcn
WIFI_DRIVER_MODULE_NAME		 := "wlan"
WIFI_DRIVER_MODULE_PATH 	 := "/system/lib/modules/wlan.ko"
WPA_SUPPLICANT_VERSION 		 := VER_0_8_X

# Basic dexpreopt
# Basic dexpreopt
ifeq ($(HOST_OS),linux)
   ifneq ($(TARGET_BUILD_VARIANT),eng)
      ifeq ($(WITH_DEXPREOPT),)
        WITH_DEXPREOPT := true
        WITH_DEXPREOPT_BOOT_IMG_ONLY := true
      endif
   endif
endif
