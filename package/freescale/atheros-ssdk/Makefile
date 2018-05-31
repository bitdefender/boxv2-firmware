# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: Makefile,v 1.17 2011/08/08 09:50:22 andrey.arsirii Exp $
#$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION)-internal/driver_linux

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/kernel-version.mk

PKG_NAME:=atheros-ssdk
PKG_VERSION:=3.01
RELEASE_VERSION:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION).tar.gz
PKG_CAT:=zcat

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install
ifeq ($(findstring linaro, $(CONFIG_GCC_VERSION)),linaro)
    ifeq ($(CONFIG_GCC_VERSION),"4.5-linaro")
      GCC_TC_VERSION:=4.5.4
    endif
    ifeq ($(CONFIG_GCC_VERSION),"4.6-linaro")
      GCC_TC_VERSION:=4.6.3
    endif
    ifeq ($(CONFIG_GCC_VERSION),"4.7-linaro")
      GCC_TC_VERSION:=4.7.1
    endif
    ifeq ($(CONFIG_GCC_VERSION),"4.8-linaro")
      GCC_TC_VERSION:=4.8.3
    endif
endif

include $(INCLUDE_DIR)/package.mk

################ OpenWRT definition ########################
define KernelPackage/atheros-ssdk/Default
  CATEGORY:=Freescale Packages
  URL:=http://www.silabs.com/
  DEPENDS:=@TARGET_comcerto2000
  MAINTAINER:=Freescale Semiconductors
endef

define KernelPackage/atheros-ssdk/Default/Description
  This package contains a driver for Atheros SSDK
endef

define KernelPackage/atheros-ssdk
  $(call KernelPackage/atheros-ssdk/Default)
  TITLE:=ATHEROS Switch SDK
  FILES:=$(PKG_BUILD_DIR)/build/bin/athrs_ar8327_drv.$(LINUX_KMOD_SUFFIX)
endef


PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_SOURCE)

ifeq ($(CONFIG_DEV_ATHEROS_SSDK), y)
ifeq ($(CONFIG_DEV_ATHEROS_SSDK_GITBRANCH), "")
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_ATHEROS_SSDK_GITTREE) atheros-ssdk-$(PKG_VERSION).$(RELEASE_VERSION) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_ATHEROS_SSDK_GITTREE) atheros-ssdk-$(PKG_VERSION).$(RELEASE_VERSION) && \
	pushd "atheros-ssdk-$(PKG_VERSION).$(RELEASE_VERSION)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_ATHEROS_SSDK_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_ATHEROS_SSDK_GITBRANCH) $(CONFIG_DEV_ATHEROS_SSDK_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_ATHEROS_SSDK_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_ATHEROS_SSDK_GITBRANCH) origin/$(CONFIG_DEV_ATHEROS_SSDK_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_ATHEROS_SSDK_GITBRANCH)\""; \
		exit 1; \
	fi; \
	popd; \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
endif
else # if Active DEV is not present
define Build/Prepare
	$(TAR) xfz $(PKG_SOURCE_FILE) -C $(KERNEL_BUILD_DIR)
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
endif

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) KERNELPATH="$(LINUX_DIR)" STAGING_DIR="$(STAGING_DIR)" \
		TOOLCHAIN_DIR="$(TOOLCHAIN_DIR)" GCC_TC_PKG_VERSION="$(GCC_TC_VERSION)" KERNEL_VER="$(KERNEL_PATCHVER)" all
endef

define Build/InstallDev
endef

define Build/UninstallDev
endef

define KernelPackage/atheros-ssdk/install
	mkdir -p $(1)/etc/atheros-ssdk-modules.d
	$(CP) $(PKG_BUILD_DIR)/build/bin/athrs_ar8327_drv.$(LINUX_KMOD_SUFFIX) $(1)/etc/atheros-ssdk-modules.d/
	mkdir -p $(1)/bin
	$(CP) $(PKG_BUILD_DIR)/build/bin/ssdk_sh $(1)/bin/
	$(CP) ./files/etc $(1)
endef

$(eval $(call KernelPackage,atheros-ssdk))
