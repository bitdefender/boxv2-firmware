#
# Copyright (C) 2007 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: Makefile,v 1.1.2.8 2011/11/16 16:56:38 baiyi.wang Exp $

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=CEEJ-Standard-Embedded-arm-v7l-linux-gnueabi-UNVALIDATED-evaluation-staticlib-bspio-jit-version
PKG_VERSION:=4.0.011.0-build
#PKG_RELEASE:=0

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_CAT:=zcat

PKG_SOURCE_URL:=http://sophial1.nice.mindspeed.com/cpe/Demos/Skelimer/JVM-4.0.011/
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/jvm_skelimer
  CATEGORY:=Freescale Packages
  DEFAULT:=n
  TITLE:=Skelimer JVM binaries 
  URL:=http://sophial1.nice.mindspeed.com/cpe/Demos/Skelimer/JVM-4.0.011
endef

define Package/jvm_skelimer/description
 This package contains a files related to the Skelimer jvm binaries.
endef


define Build/Compile/Default
endef

define Build/Compile
	$(call Build/Compile/Default)
endef

define Package/jvm_skelimer/install
### Prepare Skelimer JVM binaries directory
	$(INSTALL_DIR) $(1)/opt/jvm
	$(CP) $(PKG_BUILD_DIR)/Binaries/* $(1)/opt/jvm/
	$(CP) $(PKG_BUILD_DIR)/ceejlicense.dat $(1)/opt/jvm/
endef

$(eval $(call BuildPackage,jvm_skelimer))
