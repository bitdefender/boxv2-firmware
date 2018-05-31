# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=pfe
PKG_VERSION:=13.00
PKG_RELEASE:=2

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).tar.gz
PKG_CAT:=zcat
PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_SOURCE)

include $(INCLUDE_DIR)/package.mk

define Package/pfe
  SECTION:=Freescale Packages
  CATEGORY:=Freescale Packages
  TITLE:=PFE Firmware
  URL:=http://www.freescale.com/
endef

define Package/pfe/description
 PFE firmware.
endef

#If Development, we should download the version from our GIT instead of doing the generic process
ifeq ($(CONFIG_DEV_PFE), y)
ifeq ($(CONFIG_DEV_PFE_GITBRANCH), "")
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_PFE_GITTREE) pfe-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_PFE_GITTREE) pfe-$(PKG_VERSION).$(PKG_RELEASE) && \
	pushd "pfe-$(PKG_VERSION).$(PKG_RELEASE)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_PFE_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_PFE_GITBRANCH) $(CONFIG_DEV_PFE_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_PFE_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_PFE_GITBRANCH) origin/$(CONFIG_DEV_PFE_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_PFE_GITBRANCH)\""; \
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
define Build/Configure
endef

define Build/Compile
endef

define Package/pfe/install
	echo "pfe package"
	$(CP) ./files/lib $(1)
endef


$(eval $(call BuildPackage,pfe))
