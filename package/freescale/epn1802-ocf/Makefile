# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=epn1802-ocf
PKG_VERSION:=6.00
RELEASE_VERSION=1

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install
PKG_MODULE_NAME:=m86xxx_elp-$(PKG_VERSION).$(RELEASE_VERSION).$(LINUX_KMOD_SUFFIX)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(RELEASE_VERSION).tar.gz
PKG_CAT:=zcat

include $(INCLUDE_DIR)/package.mk

define KernelPackage/epn1802-ocf
  SECTION:=Freescale Packages
  CATEGORY:=Freescale Packages
  DEFAULT:=y
  DEPENDS:=@TARGET_comcerto2000 +kmod-crypto-ocf
  TITLE:=M86xxx HW raw crypto engine
  URL:=http://www.freescale.com/
  MAINTAINER:=Freescale Semiconductors
  FILES:= $(PKG_BUILD_DIR)/m86xxx_elp.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,09,m86xxx_elp)
endef

define KernelPackage/epn1802-ocf/description
	OCF driver for Mindspeed's Comcerto 2000 (m86xxx). Support for raw cryptography, public key acceleration and TRNG offload.
endef

PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_SOURCE)

#If Development, we should download the version from our GIT instead of doing the generic process
ifeq ($(CONFIG_DEV_EPN1802_OCF), y)
ifeq ($(CONFIG_DEV_EPN1802_OCF_GITBRANCH), "")
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" &&\
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_EPN1802_OCF_GITTREE) epn1802-ocf-$(PKG_VERSION).$(RELEASE_VERSION) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_EPN1802_OCF_GITTREE) epn1802-ocf-$(PKG_VERSION).$(RELEASE_VERSION) && \
	pushd "epn1802-ocf-$(PKG_VERSION).$(RELEASE_VERSION)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_EPN1802_OCF_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_EPN1802_OCF_GITBRANCH) $(CONFIG_DEV_EPN1802_OCF_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_EPN1802_OCF_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_EPN1802_OCF_GITBRANCH) origin/$(CONFIG_DEV_EPN1802_OCF_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_EPN1802_OCF_GITBRANCH)\""; \
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
	$(MAKE) -C $(LINUX_DIR) \
		ARCH="$(LINUX_KARCH)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		SUBDIRS="$(PKG_BUILD_DIR)" \
		EXTRA_CFLAGS=-I$(LINUX_DIR)/crypto/ocf \
		modules
	$(MAKE) -C $(LINUX_DIR) \
		ARCH="$(LINUX_KARCH)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		SUBDIRS="$(PKG_BUILD_DIR)" \
		INSTALL_MOD_PATH="$(PKG_INSTALL_DIR)" \
		modules_install
endef

define KernelPackage/epn1802-ocf/install
	mkdir -p $(1)/etc/modules.d
endef

$(eval $(call KernelPackage,epn1802-ocf))
