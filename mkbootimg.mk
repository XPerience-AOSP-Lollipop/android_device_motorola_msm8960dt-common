# Custom creation of Motorola MSM8960DT devtree

LOCAL_PATH := $(call my-dir)

# Device trees from kernel
MSM8960DT_DEVTREE := mmi-8960pro.dtb \
    msm8960ab-ghost-p0.dtb \
    msm8960ab-ghost-p1b4.dtb \
    msm8960ab-ghost-p1.dtb \
    msm8960ab-ghost-p2b.dtb \
    msm8960ab-ghost-p2.dtb \
    msm8960ab-ghost-p3.dtb \
    msm8960ab-ghost-pc.dtb \
    msm8960ab-ghost-pd.dtb \
    msm8960ab-ghost-pe.dtb \
    msm8960ab-ghost-pe.dtb \
    msm8960ab-ultra-maxx-p0.dtb \
    msm8960ab-ultra-maxx-p1.dtb \
    msm8960ab-ultra-maxx-p2.dtb \
    msm8960ab-ultra-maxx-p3.dtb \
    msm8960ab-ultram-p0.dtb \
    msm8960ab-ultram-p1.dtb \
    msm8960ab-ultram-p2c.dtb \
    msm8960ab-ultram-p2.dtb \
    msm8960ab-ultram-p3.dtb \
    msm8960ab-ultra-p0.dtb \
    msm8960ab-ultra-p1.dtb \
    msm8960ab-ultra-p2.dtb \
    msm8960ab-ultra-p3.dtb

MSM8960DT_DEVTREE_OBJ := $(addprefix $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/arch/arm/boot/,$(MSM8960DT_DEVTREE))
MOTO_DTBTOOL := $(HOST_OUT_EXECUTABLES)/dtbToolMoto$(HOST_EXECUTABLE_SUFFIX)

INSTALLED_DTIMAGE_TARGET := $(PRODUCT_OUT)/dt.img

$(INSTALLED_DTIMAGE_TARGET): $(MOTO_DTBTOOL) $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr $(INSTALLED_KERNEL_TARGET)
	$(call pretty,"Create device tree image: $@")
	$(hide) $(MOTO_DTBTOOL) -o $(INSTALLED_DTIMAGE_TARGET) $(MSM8960DT_DEVTREE_OBJ)
	@echo -e ${CL_CYN}"Made device tree image: $@"${CL_RST}

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INSTALLED_DTIMAGE_TARGET) $(INTERNAL_BOOTIMAGE_FILES) $(BOOTIMAGE_EXTRA_DEPS)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE))
	@echo -e ${CL_CYN}"Made boot image: $@"${CL_RST}

.PHONY: bootimage-nodeps
bootimage-nodeps: $(MKBOOTIMG)
	@echo "make $@: ignoring dependencies"
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $(INSTALLED_BOOTIMAGE_TARGET)
	$(hide) $(call assert-max-image-size,$(INSTALLED_BOOTIMAGE_TARGET),$(BOARD_BOOTIMAGE_PARTITION_SIZE))
	@echo -e ${CL_INS}"Made boot image: $@"${CL_RST}

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(INSTALLED_DTIMAGE_TARGET) \
		$(LZMA_RAMDISK) \
		$(recovery_uncompressed_ramdisk)
	@echo "----- Making compressed recovery ramdisk ------"
	$(hide) $(LZMA_BIN) < $(recovery_uncompressed_ramdisk) > $(recovery_ramdisk)
	@echo "----- Making recovery image ------"
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	@echo "Made recovery image: $@"
