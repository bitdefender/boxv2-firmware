# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=epavis-dpi
PKG_VERSION:=3.01
RELEASE_VERSION=1

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION).tar.gz
PKG_CAT:=zcat

include $(INCLUDE_DIR)/package.mk

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

define KernelPackage/epavis-dpi
  SECTION:=Freescale Packages
  CATEGORY:=Freescale Packages
  TITLE:=epavis dpi driver
  URL:=http://www.freescale.com/
  FILES:= $(PKG_BUILD_DIR)/cie_inspection/cie.$(LINUX_KMOD_SUFFIX) \
		$(PKG_BUILD_DIR)/decompression/decomp.$(LINUX_KMOD_SUFFIX) \
		$(PKG_BUILD_DIR)/decompression/turnkey_decomp.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/epavis/description
  DPI driver for Freescale's Comcerto 2000 . Support for dpi reg-ex acceleration, pattern matching offload.
endef

PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_SOURCE)
PKG_BUILD_FROM_SOURCE:=$(shell if [ -e $(PKG_SOURCE_FILE) ]; then echo y; fi)
ifeq ($(CONFIG_DEV_EPAVIS_DPI), y)
  PKG_BUILD_FROM_SOURCE:=y
endif

#If Development, we should download the version from our GIT instead of doing the generic process
ifeq ($(PKG_BUILD_FROM_SOURCE), y)
ifeq ($(CONFIG_DEV_EPAVIS_DPI), y)
ifeq ($(CONFIG_DEV_EPAVIS_DPI_GITBRANCH), "")
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_EPAVIS_DPI_GITTREE) epavis-dpi-$(PKG_VERSION).$(RELEASE_VERSION) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_EPAVIS_DPI_GITTREE) epavis-dpi-$(PKG_VERSION).$(RELEASE_VERSION) && \
	pushd "epavis-dpi-$(PKG_VERSION).$(RELEASE_VERSION)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_EPAVIS_DPI_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_EPAVIS_DPI_GITBRANCH) $(CONFIG_DEV_EPAVIS_DPI_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_EPAVIS_DPI_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_EPAVIS_DPI_GITBRANCH) origin/$(CONFIG_DEV_EPAVIS_DPI_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_EPAVIS_DPI_GITBRANCH)\""; \
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
endef
endif

define Build/Compile
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR)/cie_inspection \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KERNELDIR="$(LINUX_DIR)" \
		KERNELPATH="$(LINUX_DIR)" \
		DESTDIR="$(PKG_INSTALL_DIR)" all 
	$(MAKE) -C $(PKG_BUILD_DIR)/decompression \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KERNELDIR="$(LINUX_DIR)" \
		KERNELPATH="$(LINUX_DIR)" \
		DESTDIR="$(PKG_INSTALL_DIR)" all 
endef
else # if PKG_BUILD_FROM_SOURCE not set

define Build/Prepare
	echo BUILD PREPARE
endef

define Build/Compile
	mkdir -p $(PKG_BUILD_DIR)/cie_inspection
	mkdir -p $(PKG_BUILD_DIR)/decompression
	$(CP) ./files/$(BIN_PROFILE_BUILD)/cie-$(PKG_VERSION).$(RELEASE_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/cie_inspection/cie.$(LINUX_KMOD_SUFFIX)
	$(CP) ./files/$(BIN_PROFILE_BUILD)/decomp-$(PKG_VERSION).$(RELEASE_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/decompression/decomp.$(LINUX_KMOD_SUFFIX)
	$(CP) ./files/$(BIN_PROFILE_BUILD)/turnkey_decomp-$(PKG_VERSION).$(RELEASE_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/decompression/turnkey_decomp.$(LINUX_KMOD_SUFFIX)
endef
endif

define KernelPackage/epavis-dpi/install
	mkdir -p $(1)/etc/modules.d
	echo cie     >  $(1)/etc/modules.d/50-dpi
	echo decomp  >> $(1)/etc/modules.d/50-dpi
	echo turnkey_decomp  >> $(1)/etc/modules.d/50-dpi
endef

$(eval $(call KernelPackage,epavis-dpi))
