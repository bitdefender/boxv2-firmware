# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: Makefile,v 1.2 2011/01/09 18:03:12 seshu.kunapuli Exp $

include $(TOPDIR)/rules.mk

PKG_NAME:=mmiotool
PKG_VERSION:=1.00
PKG_RELEASE:=1


PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/package.mk

define Package/mmiotool
  CATEGORY:=Freescale Packages
  DEPENDS:=
  TITLE:=mmiotool
  URL:=http://www.freescale.com/
  VERSION:=$(PKG_VERSION)-$(PKG_RELEASE)
endef

define Package/mmiotool/Description
  This tool allows writing to physical memory address space (like M821xx registers) from userspace.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)
endef

define Build/Compile
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)/usr/sbin
	$(MAKE) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="-O -Wall -Wshadow -I$(STAGING_DIR)/usr/include" \
		LDFLAGS="-L$(STAGING_DIR)/usr/lib"
	cp $(PKG_BUILD_DIR)/mmiotool $(PKG_INSTALL_DIR)/usr/sbin
endef

define Package/mmiotool/install
	install -m0755 -d $(1)/usr/sbin
	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/mmiotool $(1)/usr/sbin
endef


$(eval $(call BuildPackage,mmiotool))
