#
# Copyright (C) 2007-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=hydra
PKG_VERSION:=8.1
PKG_RELEASE:=1

PKG_SOURCE:=hydra-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.thc.org/releases/
PKG_MD5SUM:=7a20011400c6282603d4b1ae461cabf2

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=COPYING

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/hydra
  SECTION:=net
  CATEGORY:=Network
  TITLE:=thc-hydra
  DEPENDS:=+libopenssl +libncurses +zlib
  URL:=https://www.thc.org/thc-hydra/
endef

define Package/hydra/description
 A very fast network logon cracker which support many different services.
endef

define Build/Prepare
	$(PKG_UNPACK)
	$(Build/Patch)
endef

define Build/Configure
endef

define Build/Compile
	(cd $(PKG_BUILD_DIR); \
	make CC="$(TARGET_CC)" XLIBPATHS="$(TARGET_LDFLAGS)" XIPATHS="$(TARGET_CFLAGS)");
endef

define Package/hydra/install
	(cd $(PKG_BUILD_DIR); make DESTDIR="$(1)" install);
endef

$(eval $(call BuildPackage,hydra))
