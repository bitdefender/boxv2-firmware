# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: Makefile,v 1.1.2.1 2007/03/16 10:25:22 yannick.vignon Exp $

include $(TOPDIR)/rules.mk

PKG_NAME:=cyclesoak
PKG_VERSION:=none
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/zc
PKG_SOURCE:=zc.tar.gz
PKG_SOURCE_URL:=http://www.zip.com.au/~akpm/linux
PKG_CAT:=zcat

PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/package.mk

define Package/cyclesoak
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libgdbm
  TITLE:= Cyclesoak
  URL:=http://www.zip.com.au/~akpm/linux/#zc
endef

define Package/cyclesoak/Description
  Give accurate CPU usage measurements.
endef

define Build/Configure
endef

define Build/Compile
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)/sbin
	$(MAKE) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="-O0 -Wall -Wshadow -I$(STAGING_DIR)/usr/include" \
		LDFLAGS="-L$(STAGING_DIR)/usr/lib" \
		zclib.o cyclesoak
	cp $(PKG_BUILD_DIR)/cyclesoak $(PKG_INSTALL_DIR)/sbin
endef

define Package/cyclesoak/install
	install -d -m0755 $(1)/sbin
	$(CP) $(PKG_INSTALL_DIR)/sbin/cyclesoak $(1)/sbin/
endef

$(eval $(call BuildPackage,cyclesoak))
