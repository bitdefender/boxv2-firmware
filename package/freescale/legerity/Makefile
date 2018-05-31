# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: Makefile,v 1.38 2011/08/08 11:56:24 andrey.arsirii Exp $
#$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION)-internal/driver_linux

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mspd-legerity
PKG_NDA_NAME:=mspd-legerity_api
PKG_VERSION:=9.02
PKG_NDA_VERSION:=9.02
RELEASE_VERSION=3
RELEASE_NDA_VERSION=3
PKG_BUILD_DEPENDS:=matisse

#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION)-internal.tar.gz
#PKG_SOURCE_URL:=http://10.1.124.219/platform_group/enterprise/drivers/legerity/releases/$(RELEASE_VERSION)/$(PKG_VERSION).$(RELEASE_VERSION)/packages/
#PKG_CAT:=zcat

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION)
PKG_NDA_SOURCE_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NDA_NAME)-$(PKG_NDA_VERSION).$(RELEASE_NDA_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION).tar.gz
PKG_NDA_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_NDA_NAME)-$(PKG_NDA_VERSION).$(RELEASE_NDA_VERSION).tar.gz
PKG_BUILD_USING_NDA_SOURCE:=$(shell if [ -e $(PKG_NDA_SOURCE_FILE) ]; then echo y; fi)
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

################ Board definition ########################

# L_DEBUG "yes or no
# L_TDM_CODING " sets the TDM coding law, possible values are : 0(alaw) 1(ulaw)
# L_SLIC_TYPE " is a table defining the type of legerity device per chip select mask value
#             "0(none) 1(LE790) 2(LE88231) 3(LE88241) 4(LE88231-megamombasa) 5(LE88231-packet_iad) 6(LE88221) 7(LE88010-FXO)
# L_LINE_TESTING "enable built-in line tests

# Common parameters
L_LINE_TESTING:=no
L_DEBUG := no

L_FLASH_TIME:=1000

ifeq ($(CONFIG_TARGET_comcerto2000),y)
        L_TDM_CODING:=1
        L_SLIC_TYPE:=0,0,0,14
        L_TIME_SLOT:=0,0,0,0,0,0,1,2
endif
ifneq ($(CONFIG_TARGET_comcerto2000_hgw_c2kmfcnevm)$(CONFIG_TARGET_comcerto2000_nas_c2kmfcnevm)$(CONFIG_TARGET_comcerto2000_hgw_nas_c2kmfcnevm),)
        L_SLIC_TYPE:=0,0,0,29
endif

################ OpenWRT definition ########################
define KernelPackage/legerity
  CATEGORY:=Freescale Packages
  DEFAULT:=y
  DEPENDS:=@TARGET_comcerto2000
  TITLE:=Legerity SLIC/SLAC
  URL:=http://www.freescale.com/
  MAINTAINER:=Freescale Semiconductors
  FILES:= $(PKG_BUILD_DIR)/legerity.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/legerity_api.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/legerity/description
  This package contains a driver for Legerity chipsets on Mindspeed boards.
endef

define KernelPackage/legerity-fxo
  CATEGORY:=Freescale Packages
  DEFAULT:=y
  DEPENDS:=@TARGET_comcerto2000
  TITLE:=Legerity FXO SLIC/SLAC
  URL:=http://www.legerity.com/
  MAINTAINER:=Freescale Semiconductors
endef

define KernelPackage/legerity-fxo/description
  This package contains a driver for Legerity chipsets on Mindspeed boards.
endef

ifeq ($(CONFIG_DEV_LEGERITY), y)
ifeq ($(CONFIG_DEV_LEGERITY_GITBRANCH), "")
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" &&\
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_LEGERITY_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION) && \
	popd

	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" &&\
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_LEGERITY_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION) && \
	pushd "$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_LEGERITY_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_LEGERITY_GITBRANCH) $(CONFIG_DEV_LEGERITY_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_LEGERITY_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_LEGERITY_GITBRANCH) origin/$(CONFIG_DEV_LEGERITY_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_LEGERITY_GITBRANCH)\""; \
		exit 1; \
	fi; \
	popd; \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
endif
else ## CONFIG_DEV_LEGERITY is not defined
define Build/Prepare
	$(TAR) xfz $(PKG_SOURCE_FILE) -C $(KERNEL_BUILD_DIR)
ifeq ($(PKG_BUILD_USING_NDA_SOURCE), y)
	$(TAR) xfz $(PKG_NDA_SOURCE_FILE) -C $(KERNEL_BUILD_DIR)
	cp -fPR $(PKG_NDA_SOURCE_DIR)/* $(PKG_BUILD_DIR)
	rm -rf $(PKG_NDA_SOURCE_DIR)
endif

	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
endif

ifneq ($(CONFIG_DEV_LEGERITY)$(PKG_BUILD_USING_NDA_SOURCE),)
  PKG_BUILD_LEGERITY_API:=y
endif

ifeq ($(PKG_BUILD_LEGERITY_API),y)
define Build/Compile
	$(call Build/Compile/Default, KERNEL_SOURCE="$(LINUX_DIR)" LINE_TESTING="$(L_LINE_TESTING)" DEBUG="$(L_DEBUG)" EXTRA_CFLAGS="-DLEGERITY_FLASH -DLEGERITY_DEB" STAGING_DIR="$(STAGING_DIR)" LEGERITY_API="yes") 
	$(CP) $(PKG_BUILD_DIR)/driver_linux/legerity.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
	$(CP) $(PKG_BUILD_DIR)/driver_linux/legerity_api.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
endef
else ### PKG_BUILD_LEGERITY_API is not y
define Build/Compile
	$(CP) ./files/$(BIN_PROFILE_BUILD)/legerity_api-$(PKG_NDA_VERSION).$(RELEASE_NDA_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/driver_linux/legerity_api.$(LINUX_KMOD_SUFFIX)
	$(call Build/Compile/Default, KERNEL_SOURCE="$(LINUX_DIR)" LINE_TESTING="$(L_LINE_TESTING)" DEBUG="$(L_DEBUG)" EXTRA_CFLAGS="-DLEGERITY_FLASH -DLEGERITY_DEB" STAGING_DIR="$(STAGING_DIR)" LEGERITY_API="no") 
	$(CP) $(PKG_BUILD_DIR)/driver_linux/legerity.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
	$(CP) $(PKG_BUILD_DIR)/driver_linux/legerity_api.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
endef
endif

define Build/InstallDev
endef

define Build/UninstallDev
endef

define KernelPackage/legerity/install
	mkdir -p $(1)/etc/slic-modules.d
	echo legerity_api > $(1)/etc/slic-modules.d/50-legerity
	echo legerity tdm_coding=$(L_TDM_CODING) slic_type=$(L_SLIC_TYPE) flash_time=$(L_FLASH_TIME) time_slot=$(L_TIME_SLOT) >> $(1)/etc/slic-modules.d/50-legerity
endef

$(eval $(call KernelPackage,legerity))
$(eval $(call KernelPackage,legerity-fxo))
