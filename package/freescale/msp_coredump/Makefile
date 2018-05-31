# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=msp-coredump
PKG_VERSION:=1.00.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/package.mk

define KernelPackage/msp-coredump
SECTION:=Freescale Packages
CATEGORY:=Freescale Packages
TITLE:=MSP Coredump Driver
URL:=http://www.freescale.com/
VERSION:=$(LINUX_VERSION)+$(PKG_VERSION)-$(BOARD)-$(PKG_RELEASE)
FILES:= $(PKG_BUILD_DIR)/msp_coredump.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/msp-coredump/description
 Driver for MSP coredump utility
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)
endef

define Build/Compile
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KERNELDIR="$(LINUX_DIR)" \
		KERNELPATH="$(LINUX_DIR)" \
		DESTDIR="$(PKG_INSTALL_DIR)" all
endef


define KernelPackage/msp-coredump/install
endef

$(eval $(call KernelPackage,msp-coredump))
