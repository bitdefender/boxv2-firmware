# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=bcm11ac
PKG_BRCM_VERSION:=63016320
PKG_MSPD_VERSION:=1.00
PKG_RELEASE:=1
PKG_VERSION:= $(PKG_BRCM_VERSION)-$(PKG_MSPD_VERSION).$(PKG_RELEASE)

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_SOURCE)

PKG_BUILD_FROM_SOURCE:=$(shell if [ -e $(PKG_SOURCE_FILE) ]; then echo y; fi)
ifeq ($(CONFIG_DEV_BROADCOM_BCM11AC), y)
  PKG_BUILD_FROM_SOURCE:=y
endif
BIN_PROFILE_BUILD:=$(PROFILE)
ifeq ($(CONFIG_TARGET_comcerto2000_nas),y)
	BIN_PROFILE_BUILD:=$(PROFILE)-nas
	ifneq ($(CONFIG_COMCERTO_PAGE_SIZE_64K),y)
		BIN_PROFILE_BUILD:=$(BIN_PROFILE_BUILD)-4k
	endif
else
	ifeq ($(CONFIG_TARGET_comcerto2000_hgw_nas),y)
		BIN_PROFILE_BUILD:=$(PROFILE)-hgw_nas
	endif
endif

ifeq ($(CONFIG_LIBC),"uClibc")
	BIN_PROFILE_BUILD:=$(BIN_PROFILE_BUILD)-uclibc
endif

include $(INCLUDE_DIR)/package.mk

#This is extra option required to surpress the LOG 
DRIVER_COMPILE_VERBOSE:=0

BROADCOM_BCM11AC_AUTOLOAD:= \
	wl

################ OpenWRT definition ########################
define KernelPackage/bcm11ac
  CATEGORY:=Freescale Packages
  DEPENDS:=@TARGET_comcerto2000 +bcm11ac
  DEPENDS:=+bcm11ac
  DEFAULT:=n
  TITLE:=Broadcom bcm11ac wifi driver (802.11 a/g/n/c) for BCM43XX chip set
  URL:=http://www.broadcom.com/
  MAINTAINER:=Freescale Semiconductors
  FILES:= $(PKG_BUILD_DIR)/wl.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,$(BROADCOM_BCM11AC_AUTOLOAD))
endef

define Package/bcm11ac
  CATEGORY:=Freescale Packages
  DEFAULT:=n
  TITLE:=Broadcom bcm11ac wifi driver (802.11 a/g/n/c) for BCM43XX chip set
  URL:=http://www.broadcom.com/
  MAINTAINER:=Freescale Semiconductors
endef

define KernelPackage/bcm11ac/description
  This package contains a driver for Broadcom bcm11ac wifi(BCM43XX chipsets) on Mindspeed boards.
endef

#if Development, we should download the version from our GIT instead of doing the generic process
ifeq ($(PKG_BUILD_FROM_SOURCE), y)
ifeq ($(CONFIG_DEV_BROADCOM_BCM11AC), y)
ifeq ($(CONFIG_DEV_BROADCOM_BCM11AC_GITBRANCH), "")

define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_BROADCOM_BCM11AC_GITTREE) $(PKG_NAME)-$(PKG_VERSION) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_BROADCOM_BCM11AC_GITTREE) $(PKG_NAME)-$(PKG_VERSION) && \
	pushd "$(PKG_NAME)-$(PKG_VERSION)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_BROADCOM_BCM11AC_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_BROADCOM_BCM11AC_GITBRANCH) $(CONFIG_DEV_BROADCOM_BCM11AC_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_BROADCOM_BCM11AC_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_BROADCOM_BCM11AC_GITBRANCH) origin/$(CONFIG_DEV_BROADCOM_BCM11AC_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_BROADCOM_BCM11AC_GITBRANCH)\""; \
		exit 1; \
	fi; \
	popd;\
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
endif
else
define Build/Prepare
	$(TAR) xfz $(PKG_SOURCE_FILE) -C $(KERNEL_BUILD_DIR)

	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
endif

define Build/Compile/wl_driver
	echo "Compiling WLAN driver : Start"
	pushd $(PKG_BUILD_DIR)/src/wl/linux && \
	$(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" LINUXDIR="$(LINUX_DIR)" \
 		LINUXVER="3.2.26" V=$(DRIVER_COMPILE_VERBOSE) \
		WLARCH=arm ARCH=arm SRCBASE="$(PKG_BUILD_DIR)/src" debug-native-apdef && \
	popd
	echo "Compiling WLAN driver : End"
	$(CP) $(PKG_BUILD_DIR)/src/wl/linux/obj-debug-native-apdef-3.2.26/wl.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
endef

define Build/Compile/wl_tool
	echo "Compiling Broadcom Proprietary Tool (wl) : Start" && \
	pushd $(PKG_BUILD_DIR)/src/wl/exe && \
	$(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" LINUXDIR="$(LINUX_DIR)" TARGETARCH=arm_le TARGETENV=linuxarm_le \
		LINUXVER="3.2.26" V=$(DRIVER_COMPILE_VERBOSE) WLARCH=arm ARCH=arm SRCBASE="$(PKG_BUILD_DIR)/src" -f GNUmakefile wlarm_le && \
	popd
	echo "Compiling Broadcom Proprietary Tool (wl) : End"
	$(CP) $(PKG_BUILD_DIR)/src/wl/exe/wlarm_le $(PKG_BUILD_DIR)/wl
endef

define Build/Compile
	echo "Broadcom Driver compilation starts here,Be patient... "
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)
	# Deals with the Broadcom Proprietary Tool.
	$(call Build/Compile/wl_tool)
	# Deals with the WLAN driver .
	$(call Build/Compile/wl_driver)
	echo "Broadcom Driver Compilation Completed , Thank you for your patience... "
endef
else 

#This is for  Release Build . This DRIVER belongs to NDA license , 
#so we will only release the binaries  in Release build.
define Build/Prepare
	echo BUILD PREPARE
endef

define Build/Compile
	# This is for Driver Module
	$(CP) ./files/$(BIN_PROFILE_BUILD)/wl-$(PKG_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/wl.$(LINUX_KMOD_SUFFIX)

	# This is for Broadcom Proprietary Tool.
	$(CP) ./files/$(BIN_PROFILE_BUILD)/wl-$(PKG_VERSION) $(PKG_BUILD_DIR)/wl
endef
endif

define Build/InstallDev
endef

define Build/UninstallDev
endef

define Package/bcm11ac/install
	echo "Broadcom WLAN utility install start"

	#Deals with the Broadcom Proprietary Tool.
	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) $(PKG_BUILD_DIR)/wl $(1)/usr/sbin/wl

	#Deals with Broadcom Provided Script to configure for STA and AP mode.
	$(CP) ./files/ap_configure.sh $(1)/usr/sbin/
	$(CP) ./files/sta_configure.sh $(1)/usr/sbin/
	
	echo "Broadcom WLAN utility install end"
endef

$(eval $(call KernelPackage,bcm11ac))
$(eval $(call BuildPackage,bcm11ac))
