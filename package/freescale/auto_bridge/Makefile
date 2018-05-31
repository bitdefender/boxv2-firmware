# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=auto_bridge
PKG_VERSION:=2.01
PKG_RELEASE:=1


PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install


PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).tar.gz
PKG_CAT:=zcat

include $(INCLUDE_DIR)/package.mk

define KernelPackage/auto_bridge
  CATEGORY:=Freescale Packages
  DEFAULT:=n
  TITLE:=Automatic bridging module 
  URL:=http://www.freescale.com/
  MAINTAINER:=Freescale Semiconductors
  FILES:= $(PKG_BUILD_DIR)/auto_bridge.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,70,auto_bridge)
endef

define KernelPackage/auto_bridge/Description
  kernel module handling automatic L2 flow detection.
endef

#If Development, we should download the version from our CVS instead of doing the generic process
ifeq ($(CONFIG_DEV_AUTO_BRIDGE), y)
ifeq ($(CONFIG_DEV_AUTO_BRIDGE_GITBRANCH), "")
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_AUTO_BRIDGE_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_AUTO_BRIDGE_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	pushd "$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_AUTO_BRIDGE_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_AUTO_BRIDGE_GITBRANCH) $(CONFIG_DEV_AUTO_BRIDGE_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_AUTO_BRIDGE_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_AUTO_BRIDGE_GITBRANCH) origin/$(CONFIG_DEV_AUTO_BRIDGE_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_AUTO_BRIDGE_GITBRANCH)\""; \
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


ifeq ($(CONFIG_PACKAGE_kmod-auto_bridge), y)

define Build/Compile
	$(call Build/Compile/Default, KERNEL_SOURCE="$(LINUX_DIR)")
endef

define Build/InstallDev
	install -d -m0755 $(STAGING_DIR)/usr/include
	$(CP) $(PKG_BUILD_DIR)/include/*.h $(STAGING_DIR)/usr/include/
endef

endif

$(eval $(call KernelPackage,auto_bridge))
