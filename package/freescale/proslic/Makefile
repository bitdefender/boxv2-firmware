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

PKG_NAME:=proslic
PKG_NDA_NAME:=proslic_api
PKG_VERSION:=6.01
PKG_NDA_VERSION:=6.01
RELEASE_VERSION:=1
RELEASE_NDA_VERSION:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION).tar.gz
PKG_NDA_SOURCE:=$(PKG_NDA_NAME)-$(PKG_NDA_VERSION).$(RELEASE_NDA_VERSION).tar.gz
PKG_CAT:=zcat

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION)
PKG_NDA_SOURCE_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NDA_NAME)-$(PKG_NDA_VERSION).$(RELEASE_NDA_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install
PKG_MODULE_NAME:=proslic-$(PKG_VERSION).$(RELEASE_VERSION).$(LINUX_KMOD_SUFFIX)
PKG_BUILD_DEPENDS:=matisse

include $(INCLUDE_DIR)/package.mk

L_FLASH_TIME:=1000
L_TDM_CODING:=2
L_NO_OF_POTS:=2
ifeq ($(CONFIG_TARGET_comcerto2000),y)
	L_SPI_CS:=1
endif

################ OpenWRT definition ########################
define KernelPackage/proslic/Default
  CATEGORY:=Freescale Packages
  URL:=http://www.silabs.com/
  DEPENDS:=@TARGET_comcerto2000
  MAINTAINER:=Freescale Semiconductors
endef

define KernelPackage/proslic/Default/Description
  This package contains a driver for ProSLIC
endef

define KernelPackage/proslic
  $(call KernelPackage/proslic/Default)
  TITLE:=SiLabs ProSLIC Driver
  FILES:=$(PKG_BUILD_DIR)/proslic.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/proslic_api.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/proslic/config
	source "$(SOURCE)/Config.in"
endef

ifeq ($(CONFIG_SI3227_FB),y)
	L_SI_PART:=SI3227
	L_SI_HAL:=2
	L_SI_CFG:=FB

	L_SPI_CS:=1
	L_TDM_MUX=0
	L_POLLING_MODE=0
	L_CALLER_ID_DELAY=250
endif

ifeq ($(CONFIG_SI3215),y)
	L_SI_PART:=SI3215
	L_SI_HAL:=1
	L_CALLER_ID_DELAY=250
endif

ifeq ($(CONFIG_SI3217X_FB),y)
	L_SI_PART:=SI3217X
	L_SI_HAL:=2
	L_SI_CFG:=FB
	L_CALLER_ID_DELAY=250
endif

ifeq ($(CONFIG_SI3217X_PBB),y)
	L_SI_PART:=SI3217X
	L_SI_HAL:=2
	L_SI_CFG:=PBB
	L_CALLER_ID_DELAY=250
endif

ifeq ($(CONFIG_SI3226X_FB),y)
	L_SI_PART:=SI3226X
	L_SI_HAL:=2
	L_SI_CFG:=FB
	L_CALLER_ID_DELAY=250
endif

ifeq ($(CONFIG_SI3226X_TSS),y)
	L_SI_PART:=SI3226X
	L_SI_HAL:=2
	L_SI_CFG:=TSS

	L_SPI_CS:=3
	L_TDM_MUX=3
	L_POLLING_MODE=1
	L_CALLER_ID_DELAY=250
endif

ifeq ($(CONFIG_SI3226X_TSS_ISO),y)
	L_SI_PART:=SI3226X
	L_SI_HAL:=2
	L_SI_CFG:=TSS_ISO

	L_SPI_CS:=3
	L_TDM_MUX=3
	L_POLLING_MODE=1
	L_CALLER_ID_DELAY=250
endif

ifeq ($(CONFIG_SI3226X_PBB),y)
	L_SI_PART:=SI3226X
	L_SI_HAL:=2
	L_SI_CFG:=PBB

	L_SPI_CS:=3
	L_TDM_MUX=3
	L_POLLING_MODE=1
	L_CALLER_ID_DELAY=250
endif

ifeq ($(CONFIG_SI3226X_PBB_JPN),y)
	L_SI_PART:=SI3226X
	L_SI_HAL:=2
	L_SI_CFG:=PBB_JPN
	L_CALLER_ID_DELAY=250
endif

ifeq ($(CONFIG_SILABS_DEBUG),y)
	L_DEBUG:=yes
endif

ifeq ($(CONFIG_SILABS_PROC_DEBUG),y)
	L_PROC_DEBUG:=yes
endif

PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_SOURCE)
PKG_NDA_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_NDA_SOURCE)
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

ifeq ($(CONFIG_DEV_PROSLIC), y)
ifeq ($(CONFIG_DEV_PROSLIC_GITBRANCH), "")
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_PROSLIC_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_PROSLIC_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION) && \
	pushd "$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_PROSLIC_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_PROSLIC_GITBRANCH) $(CONFIG_DEV_PROSLIC_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_PROSLIC_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_PROSLIC_GITBRANCH) origin/$(CONFIG_DEV_PROSLIC_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_PROSLIC_GITBRANCH)\""; \
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

ifneq ($(CONFIG_DEV_PROSLIC)$(PKG_BUILD_USING_NDA_SOURCE),)
  PKG_BUILD_PROSLIC_API:=y
endif

ifeq ($(PKG_BUILD_PROSLIC_API),y)
define Build/Compile
	  $(call Build/Compile/Default, KERNELPATH="$(LINUX_DIR)" SI_PART="$(L_SI_PART)" SI_HAL="$(L_SI_HAL)" SI_CFG="$(L_SI_CFG)" DEBUG="$(L_DEBUG)" PROC_DEBUG="$(L_PROC_DEBUG)" STAGING_DIR="$(STAGING_DIR)" PROSLIC_API="yes") 
endef
else  ## PKG_BUILD_PROSLIC_API is not set y
define Build/Compile
	$(CP) ./files/$(BIN_PROFILE_BUILD)/proslic_api-$(PKG_NDA_VERSION).$(RELEASE_NDA_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/proslic_api.$(LINUX_KMOD_SUFFIX)
	$(call Build/Compile/Default, KERNELPATH="$(LINUX_DIR)" SI_PART="$(L_SI_PART)" SI_HAL="$(L_SI_HAL)" SI_CFG="$(L_SI_CFG)" DEBUG="$(L_DEBUG)" PROC_DEBUG="$(L_PROC_DEBUG)" STAGING_DIR="$(STAGING_DIR)" PROSLIC_API="no") 
endef
endif

define Build/InstallDev
endef

define Build/UninstallDev
endef

define KernelPackage/proslic/install
	mkdir -p $(1)/etc/slic-modules.d
	echo proslic_api > $(1)/etc/slic-modules.d/99-proslic
	echo proslic tdm_coding=$(L_TDM_CODING) flash_time=$(L_FLASH_TIME) no_of_pots=$(L_NO_OF_POTS) spi_cs=$(L_SPI_CS) tdm_mux=$(L_TDM_MUX) polling_mode=$(L_POLLING_MODE) caller_id_delay=$(L_CALLER_ID_DELAY) >> $(1)/etc/slic-modules.d/99-proslic
endef

$(eval $(call KernelPackage,proslic))
