# Art
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat-swap=false

# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    persist.audio.lowlatency.rec=false \
    persist.audio.vr.enable=false \
    persist.audio.fluence.voicecall=true \
    persist.audio.fluence.voicerec=false \
    persist.audio.fluence.speaker=false \
    persist.audio.handset.mic=digital \
    ro.qc.sdk.audio.fluencetype=fluence \
    use.dedicated.device.for.voip=true \
    use.voice.path.for.pcm.voip=true \
    audio.offload.disable=1 \
    qcom.hw.aac.encoder=true \
    mm.enable.smoothstreaming=true \
    mm.enable.qcom_parser=1048575 \
    audio.offload.disable=0 \
    audio.offload.pcm.16bit.enable=false \
    audio.offload.pcm.24bit.enable=false \
    audio.offload.buffer.size.kb=32 \
    audio.offload.gapless.enabled=true \
    audio.offload.video=false

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    qcom.bt.le_dev_pwr_class=1

PRODUCT_PROPERTY_OVERRIDES += \
    ro.bluetooth.dun=false \
    ro.bluetooth.sap=false

PRODUCT_PROPERTY_OVERRIDES += \
    qcom.bluetooth.soc=smd \
    ro.bluetooth.hfp.ver=1.6 \
    ro.qualcomm.bt.hci_transport=smd

PRODUCT_PROPERTY_OVERRIDES += \
    ro.qualcomm.bluetooth.ftp=true \
    ro.qualcomm.bluetooth.hfp=true \
    ro.qualcomm.bluetooth.hsp=true \
    ro.qualcomm.bluetooth.map=true \
    ro.qualcomm.bluetooth.nap=true \
    ro.qualcomm.bluetooth.opp=true \
    ro.qualcomm.bluetooth.pbap=true

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    media.stagefright.legacyencoder=true \
    media.stagefright.less-secure=true

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    debug.composition.type=c2d \
    debug.mdpcomp.logs=0 \
    debug.sf.hw=1 \
    persist.hwc.mdpcomp.enable=true \
    ro.opengles.version=196608 \
    ro.sf.lcd_density=320

# GPS
PRODUCT_PROPERTY_OVERRIDES += \
    persist.gps.qc_nlp_in_use=0 \
    ro.gps.agps_provider=1 \
    ro.qc.sdk.izat.premium.enabled=0 \
    ro.qc.sdk.izat.service_mask=0x4

# Qualcomm
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=/system/lib/libqc-opt.so

# Radio
PRODUCT_PROPERTY_OVERRIDES += \
    rild.libargs=-d /dev/smd0 \
    rild.libpath=/system/lib/libril-qc-qmi-1.so \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.radio.dfr_mode_set=1 \
    persist.radio.eons.enabled=1 \
    persist.radio.mode_pref_nv10=1 \
    persist.radio.no_wait_for_card=1

PRODUCT_PROPERTY_OVERRIDES += \
    ro.modem.no_wdog_chk=1 \
    ro.telephony.call_ring.multiple=false \
    ro.use_data_netmgrd=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.ril_class=GhostRIL

# SSR
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.qc.sub.rdump.max=3 \
    persist.sys.ssr.restart_level=3

# Time
PRODUCT_PROPERTY_OVERRIDES += \
    persist.timed.enable=true

PRODUCT_PROPERTY_OVERRIDES += \
        debug.egl.recordable.rgba8888=1

PRODUCT_PROPERTY_OVERRIDES += \
	persist.service.adb.enable=1 \
	persist.service.debuggable=1

# USB
PRODUCT_PROPERTY_OVERRIDES += \
    ro.usb.mtp=0x2e62 \
    ro.usb.mtp_adb=0x2e63 \
    ro.usb.ptp=0x2e64 \
    ro.usb.ptp_adb=0x2e65 \
    ro.usb.bpt=0x2e28 \
    ro.usb.bpt_adb=0x2e29 \
    ro.usb.bpteth=0x2e2a \
    ro.usb.bpteth_adb=0x2e2b

# WLAN
PRODUCT_PROPERTY_OVERRIDES += \
    ro.disableWifiApFirmwareReload=true \
    wifi.interface=wlan0
