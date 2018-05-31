# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=quantenna
PKG_QUANTENNA_VERSION:=36.3.0.2
PKG_MSPD_VERSION:=1.00
PKG_RELEASE:=1
PKG_VERSION:= $(PKG_QUANTENNA_VERSION)-$(PKG_MSPD_VERSION).$(PKG_RELEASE)

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_SOURCE)


PKG_BUILD_FROM_SOURCE:=$(shell if [ -e $(PKG_SOURCE_FILE) ]; then echo y; fi)
ifeq ($(CONFIG_DEV_QUANTENNA), y)
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



QUANTENNA_AUTOLOAD:= \
	qdpc-host

define KernelPackage/quantenna
  CATEGORY:=Freescale Packages
  DEFAULT:=n
  DEPENDS:=+quantenna
  TITLE:=Quantenna WLAN driver (802.11 a/c/g/n)
  URL:=http://www.quantenna.com
  MAINTAINER:=Freescale Semiconductors
  FILES:= $(PKG_BUILD_DIR)/qdpc-host.$(LINUX_KMOD_SUFFIX) 
  AUTOLOAD:=$(call AutoLoad,50,$(QUANTENNA_AUTOLOAD))
endef

define KernelPackage/quantenna/description
  This package contains station driver for quantenna host Wi-Fi driver.
endef

define Package/quantenna
  CATEGORY:=Freescale Packages
  DEFAULT:=n
  TITLE:=quantenna (802.11 a/c/g/n) libraries
  URL:=http://www.quantenna.com
  MAINTAINER:=Freescale Semiconductors
endef

#If Development, we should download the version from our GIT instead of doing the generic process
ifeq ($(PKG_BUILD_FROM_SOURCE), y)
ifeq ($(CONFIG_DEV_QUANTENNA), y)
ifeq ($(CONFIG_DEV_QUANTENNA_GITBRANCH), "")

define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_QUANTENNA_GITTREE) $(PKG_NAME)-$(PKG_VERSION) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef

else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_QUANTENNA_GITTREE) $(PKG_NAME)-$(PKG_VERSION) && \
	pushd "$(PKG_NAME)-$(PKG_VERSION)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_QUANTENNA_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_QUANTENNA_GITBRANCH) $(CONFIG_DEV_QUANTENNA_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_QUANTENNA_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_QUANTENNA_GITBRANCH) origin/$(CONFIG_DEV_QUANTENNA_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_QUANTENNA_GITBRANCH)\""; \
		exit 1; \
	fi; \
	popd; \
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

QUANTENNA_MAKEOPTS= DESTDIR="$(STAGING_DIR)" \
		  ARCH="$(LINUX_KARCH)" \
		  CROSS_COMPILE="$(TARGET_CROSS)" \
		  TOOLPREFIX="$(KERNEL_CROSS)" \
                  TOOLPATH="$(KERNEL_CROSS)" \
		  KERNELDIR="$(LINUX_DIR)" 

define Build/Compile
	echo "Quantenna Hots Driver compilation starts here,Be patient... "
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)

	# Deals with Driver 
	$(MAKE) -C $(PKG_BUILD_DIR)/host/mindspeed $(QUANTENNA_MAKEOPTS) V=1
	$(CP) $(PKG_BUILD_DIR)/host/mindspeed/qdpc-host.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
	echo "Quantenna Driver Compilation Completed , Thank you for your patience... "
endef
else

#This is for  Release Build , This is belongs to NDA , so we will only release the binaries 
define Build/Prepare
	echo BUILD PREPARE 
endef

define Build/Compile
	# This is for Driver Module 
	$(CP) ./files/$(BIN_PROFILE_BUILD)/qdpc-host-$(PKG_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/qdpc-host.$(LINUX_KMOD_SUFFIX)
endef
endif

define Build/InstallDev
	echo InstallDev end
endef

define Build/UninstallDev
	echo UninstallDev end
endef

define Package/quantenna/install
	echo "Quantenna Binary firmware install start"
	$(INSTALL_DIR) $(1)/lib/firmware
	$(CP) ./files/topaz-linux.lzma.img $(1)/lib/firmware/
	echo "Quantenna Binary firmware install end"
endef

$(eval $(call KernelPackage,quantenna))
$(eval $(call BuildPackage,quantenna))
