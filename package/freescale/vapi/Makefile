#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=vapi
PKG_VERSION:=2.18.4

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_CAT:=zcat

PKG_SOURCE_URL:=http://sophial1.nice.mindspeed.com/platform/vapi/releases/2.18/
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install
PKG_MD5SUM:=7110485aeb1c24dd9bbbf33083b4cd04
DEPENDS:=+argp-standalone

include $(INCLUDE_DIR)/package.mk

define Package/vapi/Default
	CATEGORY:=Freescale Packages
	URL:=http://www.freescale.com/
    MAINTAINER:=Freescale Semiconductors
endef

define Package/vapi
	$(call Package/vapi/Default)
	DEFAULT:=m
	TITLE:=The VAPI library
endef

define Package/vapi/description
	This library provides a high level API\
	that hides the details of communicating commands with\
	 a Media Stream Processor.
endef

define Package/kmod-csme
	$(call Package/vapi/Default)
	DEFAULT:=m
	TITLE:=csme kernel module
	VERSION:=$(LINUX_VERSION)+$(PKG_VERSION)-$(BOARD)-$(PKG_RELEASE)
endef

define Package/kmod-csme/description
	Kernel module implementing CSME protocol stack and socket interface.
endef

define Build/Prepare
	$(call Build/Prepare/Default,)	
endef

define Build/vapi/Compile
	$(MAKE) -C "$(PKG_BUILD_DIR)"/LxProj \
	        ARCH="arm" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		FSROOT="$(PKG_INSTALL_DIR)" \
		GTL_DEV_CONFIG="NO" \
		install
endef

define Build/kmod-csme/Compile
	$(MAKE) -C "$(PKG_BUILD_DIR)"/VAPI/linux/gtl_csme/csmencaps \
		ARCH="$(LINUX_KARCH)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KERNEL_DIR="$(LINUX_DIR)" \
		PREFIX="$(PKG_INSTALL_DIR)" \
		modules modules_install
endef

define Build/Compile
	$(call Build/vapi/Compile)
	$(call Build/kmod-csme/Compile)
endef

define Package/vapi/install
	mkdir -p $(STAGING_DIR)/lib
	mkdir -p $(STAGING_DIR)/include/vapi
	$(CP) -a $(PKG_INSTALL_DIR)/usr/local/lib/* $(STAGING_DIR)/lib/
	$(CP) -a $(PKG_INSTALL_DIR)/usr/local/include/vapi/* $(STAGING_DIR)/include/vapi

	mkdir -p $(1)/usr/lib
	$(CP) -a $(PKG_INSTALL_DIR)/usr/local/lib/* $(1)/usr/lib/
endef

define Package/kmod-csme/install
	mkdir -p $(1)/lib/modules/$(LINUX_VERSION)
	mkdir -p $(1)/etc/init.d
	$(CP) -a $(PKG_INSTALL_DIR)/lib/modules/$(LINUX_VERSION)/extra/* $(1)/lib/modules/$(LINUX_VERSION)/
	$(CP) ./files/etc $(1)/
endef

$(eval $(call BuildPackage,vapi))
$(eval $(call BuildPackage,kmod-csme))
