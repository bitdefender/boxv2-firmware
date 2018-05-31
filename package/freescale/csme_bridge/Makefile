# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: Makefile,v 1.1 2006/08/10 13:38:50 silvano.dininno Exp $

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=csme-bridge
PKG_VERSION:=1.00.1
PKG_RELEASE:=1


PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/package.mk

define Package/kmod-csme-bridge
  CATEGORY:=Freescale Packages
  DEPENDS:=
  TITLE:=CSM Encaps bridge kernel module
  URL:=http://www.freescale.com/
  VERSION:=$(LINUX_VERSION)+$(PKG_VERSION)-$(BOARD)-$(PKG_RELEASE)
endef

define Package/kmod-csme-bridge/Description
  The CSM Emcaps bridge module enambles an external host to control a CPE Comcerto device
endef

define Package/kmod-csme-bridge/conffiles
/etc/init.d/csme-bridge-prepare
/etc/init.d/csme-bridge-loader
/etc/init.d/matisse-no-ifup
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

define Package/kmod-csme-bridge/install
	mkdir -p $(1)/lib/modules/$(LINUX_VERSION)
	$(CP) -a $(PKG_INSTALL_DIR)/lib/modules/$(LINUX_VERSION)/extra/* \
		$(1)/lib/modules/$(LINUX_VERSION)/
	$(CP) ./files/etc $(1)
endef


$(eval $(call BuildPackage,kmod-csme-bridge))
