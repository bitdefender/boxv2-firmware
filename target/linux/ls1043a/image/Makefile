#
# Copyright (C) 2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

BOARD_TYPE:=rdb
PLATFORM:=ls
SUBPLATFORM:=hgw
ifeq ($(CONFIG_TARGET_ls1043a_hgw),y)
	SUBPLATFORM:=hgw
endif
ifeq ($(CONFIG_TARGET_ls1043a_hgw_lsrdb),y)
	BOARD_TYPE:=rdb
endif
ifeq ($(CONFIG_TARGET_ls1043a_hgw_lsqds),y)
	BOARD_TYPE:=qds
endif

ifeq ($(CONFIG_TARGET_ls1043a_hgw_ls1012aqdsintpsr),y)
	BOARD_TYPE:=ls1012aqdsintpsr
endif

define Image/Prepare
	-rm -rf $(KDIR)/linux-system.axf
	cp $(LINUX_DIR)/arch/$(LINUX_KARCH)/boot/Image $(KDIR)/Image
	$(MAKE) -C boot-wrapper clean
	$(MAKE) -C boot-wrapper compile
endef

define Build/Clean
	$(MAKE) -C boot-wrapper clean
endef

define Image/Build/QemuVirt
	$(CP) $(KDIR)/Image $(BIN_DIR)/openwrt-$(BOARD)-qemu-virt.Image
ifneq ($(CONFIG_TARGET_ROOTFS_INITRAMFS),)
	$(CP) $(KDIR)/Image-initramfs $(BIN_DIR)/openwrt-$(BOARD)-qemu-virt-initramfs.Image
endif
endef

define Image/Build/VexpressFoundation
	$(CP) $(KDIR)/linux-system.axf $(BIN_DIR)/openwrt-$(BOARD)-vexpress-foundation.axf
endef

define Image/BuildKernel
	$(call Image/Build/QemuVirt)
	$(call Image/Build/VexpressFoundation)
endef

define Image/Build/squashfs
	$(call prepare_generic_squashfs,$(KDIR)/root.squashfs)
endef

ifeq ($(CONFIG_ITB_IMAGE),y)
define Image/Build/itb
	gzip -9 -c $(KDIR)/Image > $(KDIR)/Image.gz
	$(CP) $(BIN_DIR)/openwrt-$(BOARD)-$(SUBPLATFORM)-${PROFILE}-rootfs.tar.gz $(KDIR)/
	$(CP) $(LINUX_DIR)/arch/$(LINUX_KARCH)/boot/dts/freescale/fsl-$(BOARD)-$(BOARD_TYPE).dtb $(KDIR)/
	$(CP) $(LINUX_DIR)/kernel-$(BOARD)-$(BOARD_TYPE).its $(KDIR)/
	$(SED) 's/arch\/arm64\/boot\/Image.gz/Image.gz/' $(KDIR)/kernel-$(BOARD)-$(BOARD_TYPE).its
	$(SED) 's/arch\/arm64\/boot\/dts\/freescale\/fsl-$(BOARD)-$(BOARD_TYPE).dtb/fsl-$(BOARD)-$(BOARD_TYPE).dtb/' $(KDIR)/kernel-$(BOARD)-$(BOARD_TYPE).its
	$(SED) 's/fsl-image-core-${BOARD}${BOARD_TYPE}.ext2.gz/openwrt-$(BOARD)-$(SUBPLATFORM)-${PROFILE}-rootfs.tar.gz/' $(KDIR)/kernel-$(BOARD)-$(BOARD_TYPE).its
	pushd $(KDIR) &&\
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) &&\
	mkimage -f kernel-$(BOARD)-$(BOARD_TYPE).its openwrt-$(BOARD)-$(SUBPLATFORM)-${PROFILE}.itb &&\
	$(CP) openwrt-$(BOARD)-$(SUBPLATFORM)-${PROFILE}.itb $(BIN_DIR)/ &&\
	popd
endef
else
define Image/Build/itb
	true
endef
endif

define Image/Build
	$(call Image/Build/$(1))
	dd if=$(KDIR)/root.$(1) of=$(BIN_DIR)/openwrt-$(BOARD)-root.$(1) bs=128k conv=sync
endef

$(eval $(call BuildImage))
