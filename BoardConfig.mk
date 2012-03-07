# Samsung YP-G1 compile definitions.

BOARD_PROVIDES_BOOTMODE := true

BOARD_USES_UBOOT := false
BOARD_USES_UBOOT_MULTIIMAGE := false

# Set this up here so that BoardVendorConfig.mk can override it
BOARD_USES_GENERIC_AUDIO := false

BOARD_USES_LIBSECRIL_STUB := true

# Use the non-open-source parts, if they exist
-include vendor/samsung/ypg1/BoardConfigVendor.mk

# Processor optimizations
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_GLOBAL_CFLAGS += -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp
ARCH_ARM_HAVE_TLS_REGISTER := true
ANDROID_ARM_LINKER := true

TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

TARGET_BOARD_PLATFORM := s5pc110
TARGET_BOARD_PLATFORM_GPU := POWERVR_SGX540_120
TARGET_BOOTLOADER_BOARD_NAME := s5pc110

TARGET_PROVIDES_INIT := true
TARGET_PROVIDES_INIT_TARGET_RC := true
TARGET_RECOVERY_INITRC := device/samsung/ypg1/recovery.rc

# Provide our own libaudio
TARGET_PROVIDES_LIBAUDIO := true

# Releasetools
TARGET_RELEASETOOL_OTA_FROM_TARGET_SCRIPT := ./device/samsung/ypg1/releasetools/ypg1_ota_from_target_files
TARGET_RELEASETOOL_IMG_FROM_TARGET_SCRIPT := ./device/samsung/ypg1/releasetools/ypg1_img_from_target_files

# Camera defines
USE_CAMERA_STUB := false
ifeq ($(USE_CAMERA_STUB),false)
BOARD_CAMERA_LIBRARIES := libcamera
endif

# OpenGL stuff
BOARD_EGL_CFG := device/samsung/ypg1/prebuilt/etc/egl.cfg

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true

# Video Devices
BOARD_USES_OVERLAY := true
BOARD_V4L2_DEVICE := /dev/video1
BOARD_CAMERA_DEVICE := /dev/video0
BOARD_SECOND_CAMERA_DEVICE := /dev/video2

# XXX
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 268435456

# Max image/partition sizes
# XXX: check and fix
BOARD_BOOTIMAGE_MAX_SIZE := $(call image-size-from-data-size,0x00280000)
BOARD_RECOVERYIMAGE_MAX_SIZE := $(call image-size-from-data-size,0x00500000)
BOARD_SYSTEMIMAGE_MAX_SIZE := $(call image-size-from-data-size,0x07500000)
BOARD_USERDATAIMAGE_MAX_SIZE := $(call image-size-from-data-size,0x04ac0000)
# The size of a block that can be marked bad.
BOARD_FLASH_BLOCK_SIZE := 131072

# Kernel defines
BOARD_NAND_PAGE_SIZE := 4096 -s 128
BOARD_KERNEL_BASE := 0x02e00000
BOARD_KERNEL_CMDLINE := console=ttyFIQ0,115200 init=/init no_console_suspend
BOARD_KERNEL_PAGESIZE := 4096
TARGET_PREBUILT_KERNEL := device/samsung/ypg1/kernel

# WIFI defines
BOARD_WPA_SUPPLICANT_DRIVER := WEXT
WPA_SUPPLICANT_VERSION := VER_0_6_X
BOARD_WLAN_DEVICE := bcm4329
WIFI_DRIVER_FW_STA_PATH := "/system/etc/wifi/bcm4329_sta.bin"
WIFI_DRIVER_FW_AP_PATH := "/system/etc/wifi/bcm4329_aps.bin"
WIFI_DRIVER_MODULE_PATH := "/lib/modules/dhd.ko"
WIFI_DRIVER_MODULE_ARG := "firmware_path=/system/etc/wifi/bcm4329_sta.bin nvram_path=/system/etc/wifi/nvram_net.txt"
WIFI_DRIVER_MODULE_NAME := "dhd"

# Recovery
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_RECOVERY_HANDLES_MOUNT := true
BOARD_USES_BML_OVER_MTD := false
BOARD_CUSTOM_RECOVERY_KEYMAPPING:= ../../device/samsung/ypg1/recovery_ui.c
BOARD_CUSTOM_BOOTIMG_MK := device/samsung/ypg1/shbootimg.mk
TARGET_OTA_ASSERT_DEVICE := YP-G1

-include device/samsung/aries-common/bdaddr_read/Android.mk
