# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=cdx
PKG_VERSION:=0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).tar.gz
PKG_CAT:=zcat
PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_SOURCE)

include $(INCLUDE_DIR)/package.mk

define KernelPackage/cdx
  SECTION:=Freescale Packages
  CATEGORY:=Freescale Packages
  TITLE:=CMM DPAA translator 
  URL:=http://www.freescale.com/
  FILES:= $(PKG_BUILD_DIR)/cdx.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/cdx/description
  CMM DPAA translator - Which takes CMM commands , store them in internal strucutres and program DPAA for FAST PATH.
endef


#If Development, we should download the version from our GIT instead of doing the generic process
ifeq ($(CONFIG_DEV_CDX), y)
ifeq ($(CONFIG_DEV_CDX_GITBRANCH), "")
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_CDX_GITTREE) cdx-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_CDX_GITTREE) cdx-$(PKG_VERSION).$(PKG_RELEASE) && \
	pushd "cdx-$(PKG_VERSION).$(PKG_RELEASE)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_CDX_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_CDX_GITBRANCH) $(CONFIG_DEV_CDX_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_CDX_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_CDX_GITBRANCH) origin/$(CONFIG_DEV_CDX_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_CDX_GITBRANCH)\""; \
		exit 1; \
	fi; \
	popd; \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
endif
endif

ifeq ($(CONFIG_TARGET_ls1043a)$(CONFIG_TARGET_ls1012a),y)
	TARGET_BOARD_ARCH:=arm64
ifeq ($(CONFIG_TARGET_ls1043a),y)
	TARGET_BOARD_NAME:=LS1043A
else
	TARGET_BOARD_NAME:=LS1012A
endif
endif
ifeq ($(CONFIG_TARGET_comcerto2000),y)
	TARGET_BOARD_ARCH:=arm
	TARGET_BOARD_NAME:=LS1024A
endif

define Build/Compile
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KERNELDIR="$(LINUX_DIR)" \
		PLATFORM="$(TARGET_BOARD_NAME)" \
		ARCH="$(TARGET_BOARD_ARCH)" \
		DESTDIR="$(PKG_INSTALL_DIR)" all 
endef

define KernelPackage/cdx/install
	$(CP) ./files/etc $(1)/
endef
define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/cdx
	$(CP) $(PKG_BUILD_DIR)/cdx_ioctl.h $(1)/usr/include/cdx
	$(CP) $(PKG_BUILD_DIR)/cdx_common.h $(1)/usr/include/cdx
endef

$(eval $(call KernelPackage,cdx))
