# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=c2k_pmu
PKG_VERSION:=1.00
PKG_RELEASE:=1


PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/package.mk

define Package/kmod-c2k_pmu
  CATEGORY:=Freescale Packages
  DEPENDS:=
  TITLE:=Comcerto 2000 ARM926 PMU Driver
  URL:=http://www.freescale.com/
  VERSION:=$(LINUX_VERSION)+$(PKG_VERSION)-$(BOARD)-$(PKG_RELEASE)
endef

define Package/kmod-c2k_pmu/Description
  The driver initialize and load ARM926 core with the PMU firmware
endef


define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)
endef

define Build/Compile
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)
	$(MAKE) -C $(LINUX_DIR) \
		ARCH="$(LINUX_KARCH)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		SUBDIRS="$(PKG_BUILD_DIR)" \
		modules
	$(MAKE) -C $(LINUX_DIR) \
		ARCH="$(LINUX_KARCH)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		SUBDIRS="$(PKG_BUILD_DIR)" \
		INSTALL_MOD_PATH="$(PKG_INSTALL_DIR)" \
		modules_install
endef

define Package/kmod-c2k_pmu/install
	mkdir -p $(1)/lib/modules/$(LINUX_VERSION)
	$(CP) -a $(PKG_INSTALL_DIR)/lib/modules/$(LINUX_VERSION)/extra/* \
		$(1)/lib/modules/$(LINUX_VERSION)/
	$(CP) ./files/etc $(1)
endef


$(eval $(call BuildPackage,kmod-c2k_pmu))
