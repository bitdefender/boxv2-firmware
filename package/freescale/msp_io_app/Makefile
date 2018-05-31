# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=msp-io-app
PKG_VERSION:=1.00.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/package.mk

define Package/msp-io-app
SECTION:=Freescale Packages
CATEGORY:=Freescale Packages
TITLE:=MSP Coredump Utility
DEPENDS:=+zlib +USE_UCLIBC:libpthread
URL:=http://www.freescale.com/
VERSION:=$(LINUX_VERSION)+$(PKG_VERSION)-$(BOARD)-$(PKG_RELEASE)
endef

define Package/msp-io-app/description
 Dumps the SDRAM memory used by MSP
endef

#ifeq ($(CONFIG_PACKAGE_msp-io-app), y)
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)
endef
#endif

EXTRA_CFLAGS:= -I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/include -DDALI
EXTRA_LDFLAGS:= -L$(STAGING_DIR)/lib   -L$(STAGING_DIR)/usr/lib

#ifeq ($(CONFIG_PACKAGE_msp-io-app), y)
define Build/Compile
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)
	$(MAKE) -C "$(PKG_BUILD_DIR)" \
		CROSS_ARCH="Linux" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		CROSS_COMPILE_BIN="/void/" \
		HOST_CC="$(HOSTCC)" \
		OPTIMIZE="$(TARGET_CFLAGS)" \
		PROC="$(ARCH)" \
		DEBUG="" \
		EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \
		EXTRA_LDFLAGS="$(EXTRA_LDFLAGS)" \
		PKG_INSTALL_DIR="$(PKG_INSTALL_DIR)"\
		all install
endef
#endif


#ifeq ($(CONFIG_PACKAGE_msp-io-app), y)
define Package/msp-io-app/install
	mkdir -p $(1)/bin
	$(CP) -a $(PKG_INSTALL_DIR)/* \
		$(1)/bin
endef
#endif

$(eval $(call BuildPackage,msp-io-app))
