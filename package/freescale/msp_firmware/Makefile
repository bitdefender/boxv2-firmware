# 
# Copyright (C) 2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=msp_firmware
PKG_VERSION:=6.00.1
PKG_RELEASE:=1
MSP_NAME:=voip.axf

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/package.mk

define Package/msp-firmware
SECTION:=Freescale Packages
CATEGORY:=Freescale Packages
DEPENDS:=
TITLE:=VoIP Firmware
URL:=http://www.freescale.com/
VERSION:=$(LINUX_VERSION)+$(PKG_VERSION)-$(BOARD)-$(PKG_RELEASE)
endef

define Package/msp-firmware/description
	VoIP Firmware.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./files/lib/firmware/$(MSP_NAME) $(PKG_BUILD_DIR)/$(MSP_NAME)
endef

define Build/Compile
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)/lib/firmware
	cp -a $(PKG_BUILD_DIR)/$(MSP_NAME) $(PKG_INSTALL_DIR)/lib/firmware
endef

define Package/msp-firmware/install
	mkdir -p $(1)/lib/firmware
	$(CP) -a $(PKG_INSTALL_DIR)/lib/firmware/* $(1)/lib/firmware/
endef

$(eval $(call BuildPackage,msp-firmware))
