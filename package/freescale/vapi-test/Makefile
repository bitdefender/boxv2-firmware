#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=vapi-test
PKG_VERSION:=2.18.3

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_CAT:=zcat

PKG_SOURCE_URL:=http://sophial1.nice.mindspeed.com/platform/vapi/releases/2.18/
PKG_BUILD_DIR:=$(BUILD_DIR)/vapi_sanity
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install
PKG_MD5SUM:=75e2e3e48651274a91988d7476bd9736
PKG_BUILD_DEPENDS:=argp-standalone vapi

include $(INCLUDE_DIR)/package.mk

define Package/vapi/Default
	CATEGORY:=Freescale Packages
	URL:=http://www.freescale.com/
    MAINTAINER:=Freescale Semiconductors
endef

define Package/vapi/Default/Description
	This library provides a high level API that hides the details of communicating commands with\
	 a Media Stream Processor.
endef

define Package/vapi-test
	$(call Package/vapi/Default)
	DEPENDS:=+vapi +USE_UCLIBC:libpthread
	DEFAULT:=m
	TITLE:=The VAPI sanity tests
endef

define Package/vapi-test/Description
	Provide good example how to use VAPI. Can be used for different kind of tests.
endef

define Build/vapi-test/Compile
	$(MAKE) -C "$(PKG_BUILD_DIR)" \
		BUILD_DIR="$(BUILD_DIR)" \
		FSTYPE="OpenWrt" \
		FSROOT="$(PKG_INSTALL_DIR)" \
		VAPI_TEST_STAG_DIR="$(STAGING_DIR)" \
		CROSS_COMPILE="$(TARGET_CROSS)gcc" \
		CC="$(TARGET_CROSS)gcc"
endef

define Build/Compile
	$(call Build/vapi-test/Compile)
endef


define Package/vapi-test/install
	mkdir -p $(1)/usr/local/bin/
	mkdir -p $(1)/usr/local/etc/
	$(CP) -a $(PKG_BUILD_DIR)/vapi_san $(1)/usr/local/bin/ 
	$(CP) ./files/usr $(1)/
endef

$(eval $(call BuildPackage,vapi-test))
