# 
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

ifeq ("$(strip $(ARCH))","armeb")
ARCH:=arm
endif

JFFS2_BLOCKSIZE = 128k
JFFS2_NAND_BLOCKSIZE ?= 1024k
#NAND_BLOCKSIZE=$(JFFS2_NAND_BLOCKSIZE)
JFFS2_NAND_OPTS := -n -p 4096

ifneq ($(CONFIG_TARGET_UBIFS_NAND_MIN_IO_SIZE),)
  UBIFS_NAND_OPTS += -U -q -m $(CONFIG_TARGET_UBIFS_NAND_MIN_IO_SIZE)
  UBINIZE_NAND_OPTS += -m $(CONFIG_TARGET_UBIFS_NAND_MIN_IO_SIZE)
endif
ifneq ($(CONFIG_TARGET_UBIFS_NAND_PHYSICAL_ERASE_BLOCK_SIZE),)
  UBINIZE_NAND_OPTS += -p $(CONFIG_TARGET_UBIFS_NAND_PHYSICAL_ERASE_BLOCK_SIZE)
endif
ifneq ($(CONFIG_TARGET_UBIFS_NAND_SUB_PAGE_SIZE),"")
  UBINIZE_NAND_OPTS += -s $(CONFIG_TARGET_UBIFS_NAND_SUB_PAGE_SIZE)
endif
ifneq ($(CONFIG_TARGET_UBIFS_NAND_LOGICAL_ERASE_BLOCK_SIZE),)
  UBIFS_NAND_OPTS += -e $(CONFIG_TARGET_UBIFS_NAND_LOGICAL_ERASE_BLOCK_SIZE)
endif
ifneq ($(CONFIG_TARGET_UBIFS_NAND_MAX_LEB_COUNT),)
  UBIFS_NAND_OPTS += -c $(CONFIG_TARGET_UBIFS_NAND_MAX_LEB_COUNT)
endif
ifneq ($(CONFIG_TARGET_UBIFS_NAND_IMAGE_NAME),"")
  UBIFS_NAND_IMAGE_CMD = cp -f $(KDIR)/root.ubi $(CONFIG_TARGET_UBIFS_NAND_IMAGE_NAME)
endif
  UBIFS_NAND_OPTS += -x zlib

ifneq ($(CONFIG_TARGET_UBIFS_NOR_MIN_IO_SIZE),)
  UBIFS_NOR_OPTS += -U -q -m $(CONFIG_TARGET_UBIFS_NOR_MIN_IO_SIZE)
  UBINIZE_NOR_OPTS += -m $(CONFIG_TARGET_UBIFS_NOR_MIN_IO_SIZE)
endif
ifneq ($(CONFIG_TARGET_UBIFS_NOR_PHYSICAL_ERASE_BLOCK_SIZE),)
  UBINIZE_NOR_OPTS += -p $(CONFIG_TARGET_UBIFS_NOR_PHYSICAL_ERASE_BLOCK_SIZE)
endif
ifneq ($(CONFIG_TARGET_UBIFS_NOR_LOGICAL_ERASE_BLOCK_SIZE),)
  UBIFS_NOR_OPTS += -e $(CONFIG_TARGET_UBIFS_NOR_LOGICAL_ERASE_BLOCK_SIZE)
endif
ifneq ($(CONFIG_TARGET_UBIFS_NOR_MAX_LEB_COUNT),)
  UBIFS_NOR_OPTS += -c $(CONFIG_TARGET_UBIFS_NOR_MAX_LEB_COUNT)
endif
ifneq ($(CONFIG_TARGET_UBIFS_NOR_IMAGE_NAME),"")
  UBIFS_NOR_IMAGE_CMD = cp -f $(KDIR)/root.ubi $(CONFIG_TARGET_UBIFS_NOR_IMAGE_NAME)
endif
  UBIFS_NOR_OPTS += -x zlib


kernel_hdr_gen_configuration="null:::uImage::"
ifeq ($(CONFIG_SECURE_BOOT),y)
ifeq ($(CONFIG_SECURE_BOOT_NULL),y)
	kernel_hdr_gen_configuration="null:::uImage::"
endif
ifeq ($(CONFIG_SECURE_BOOT_HASH),y)
	kernel_hdr_gen_configuration="sha256:::uImage::"
endif
ifeq ($(CONFIG_SECURE_BOOT_RSA_HASH_NO_KEY),y)
	kernel_hdr_gen_configuration="rsa:privatekey-2k.pem:nokey:uImage::"
endif
ifeq ($(CONFIG_SECURE_BOOT_RSA_HASH_INSERT_KEY),y)
	kernel_hdr_gen_configuration="rsa:privatekey-2k.pem:insertkey:uImage::"
endif
ifeq ($(CONFIG_SECURE_BOOT_AES_RSA_HASH_NO_KEY),y)
	kernel_hdr_gen_configuration="aes_rsa:privatekey-2k.pem:nokey:uImage:128:"
endif
ifeq ($(CONFIG_SECURE_BOOT_AES_RSA_HASH_INSERT_KEY),y)
	kernel_hdr_gen_configuration="aes_rsa:privatekey-2k.pem:insertkey:uImage:128:"
endif
endif


ifneq ($(CONFIG_TARGET_ROOTFS_JFFS2),)
define Image/mkfs/jffs2/sub
	$(STAGING_DIR_HOST)/bin/mkfs.jffs2 $(JFFS2OPTS) $(3) -e $(patsubst %k,%KiB,$(1)) -o $(KDIR)/root.jffs2-$(1) -d $(TARGET_DIR) -v 2>&1 1>/dev/null | awk '/^.+$$$$/'
	$(call add_jffs2_mark,$(KDIR)/root.jffs2-$(1))
	$(call Image/Build,jffs2-$(1))
endef
define Image/mkfs/jffs2
	$(foreach SZ,$(JFFS2_BLOCKSIZE),$(call Image/mkfs/jffs2/sub,$(SZ)))
	$(foreach SZ,$(JFFS2_NAND_BLOCKSIZE),$(call Image/mkfs/jffs2/sub,$(SZ),nand-,$(JFFS2_NAND_OPTS)))
endef
endif

ifneq ($(CONFIG_TARGET_ROOTFS_UBIFS),)
define Image/mkfs/ubifs
	$(CP) ./ubinize_nor.cfg $(KDIR)
	$(STAGING_DIR_HOST)/bin/mkfs.ubifs $(UBIFS_NOR_OPTS) -o $(KDIR)/root.ubifs_nor -d $(TARGET_DIR)
	(cd $(KDIR); \
	$(STAGING_DIR_HOST)/bin/ubinize $(UBINIZE_NOR_OPTS) -o $(KDIR)/root.ubi_nor ubinize_nor.cfg)
	$(call Image/Build,ubi_nor)
	$(UBIFS_NOR_IMAGE_CMD)
	$(CP) ./ubinize_nand.cfg $(KDIR)
	$(STAGING_DIR_HOST)/bin/mkfs.ubifs $(UBIFS_NAND_OPTS) -o $(KDIR)/root.ubifs_nand -d $(TARGET_DIR)
	(cd $(KDIR); \
	$(STAGING_DIR_HOST)/bin/ubinize $(UBINIZE_NAND_OPTS) -o $(KDIR)/root.ubi_nand ubinize_nand.cfg)
	$(call Image/Build,ubi_nand)
	$(UBIFS_NAND_IMAGE_CMD)
endef
endif

define Build/Clean
endef

define Build/Compile
endef

define Image/Prepare

endef

define gen_c2k_key
	pushd $(SCRIPT_DIR)/c2k_key_gen; \
	./key_gen.sh ; \
	popd
endef
ifeq ($(CONFIG_TARGET_COMCERTO_RAMDISK),y)
define Image/mkfs/ramdisk
	$(SCRIPT_DIR)/comcerto_generate_ramdisk.sh $(TARGET_DIR) $(BIN_DIR)/$(IMG_PREFIX)-ramdisk.cpio.gz $(PLATFORM_DIR)/ramdisk-files
ifeq ($(CONFIG_TARGET_COMCERTO_MULTI_IMAGE),y)
	$(STAGING_DIR_HOST)/bin/mkimage -A arm -O linux -T multi -C none -a 0x3008000 -e 0x3008000 -n $(IMG_PREFIX) -d $(LINUX_DIR)/arch/$(ARCH)/boot/zImage:$(BIN_DIR)/$(IMG_PREFIX)-ramdisk.cpio.gz $(BIN_DIR)/$(IMG_PREFIX)-multi-uImage.img
else
	$(STAGING_DIR_HOST)/bin/mkimage -A arm -O linux -T ramdisk -C none -a 0x01A00000 -e 0x01A00000 -d $(BIN_DIR)/$(IMG_PREFIX)-ramdisk.cpio.gz $(BIN_DIR)/$(IMG_PREFIX)-ramdisk.img
endif
endef
else
define Image/mkfs/ramdisk
endef
endif

define Image/BuildKernel
	$(call gen_c2k_key)
	pushd  $(BIN_DIR)/keys ; \
	cp *.key *.rawkey *.pem publickeyhash-* $(TOPDIR)/target/linux/comcerto2000/image/ImageGenarator/ ; \
	popd ; \
	$(CP) $(LINUX_DIR)/../uImage $(TOPDIR)/target/linux/comcerto2000/image/ImageGenarator/ ; \
	pushd $(TOPDIR)/target/linux/comcerto2000/image/ImageGenarator/ ; \
	head -n -1 hdr_gen_cfg > hdr_gen_cfg_tmp ; \
	mv hdr_gen_cfg_tmp hdr_gen_cfg ; \
	echo $(kernel_hdr_gen_configuration) >> hdr_gen_cfg ; \
	chmod 755 *.sh ; \
	./kernel_gen.sh 1>/dev/null ; \
	popd
	$(CP) $(TOPDIR)/target/linux/comcerto2000/image/ImageGenarator/uImage1 $(BIN_DIR)/$(IMG_PREFIX)-uImage.img
	$(CP) $(LINUX_DIR)/../vmlinux $(BIN_DIR)/$(IMG_PREFIX)-vmlinux
	$(call Image/mkfs/ramdisk,)
endef

define Image/Build
	$(CP) $(KDIR)/root.$(1) $(BIN_DIR)/$(IMG_PREFIX)-rootfs-$(1).img
endef

$(eval $(call BuildImage))
