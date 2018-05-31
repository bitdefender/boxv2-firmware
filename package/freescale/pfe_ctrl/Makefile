# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=pfe_ctrl
PKG_VERSION:=13.00
PKG_RELEASE:=1
FSL_FEED_PATH1:=$(shell if [ -e $(TOPDIR)/feeds.conf ]; then (grep "freescalecustomfeeds" $(TOPDIR)/feeds.conf) | cut -d' ' -f 3; fi)
FSL_FEED_PATH:=$(shell if [ -z $(FSL_FEED_PATH1) ]; then (grep "freescalecustomfeeds" $(TOPDIR)/feeds.conf.default) | cut -d' ' -f 3; else echo $(FSL_FEED_PATH1) fi)
PFE_PKG_PATH:=$(shell if [ -e $(TOPDIR)/package/freescale/pfe/Makefile ]; then echo $(TOPDIR)/package/freescale/pfe/Makefile; else if [ -e $(FSL_FEED_PATH)/pfe/Makefile ]; then echo $(FSL_FEED_PATH)/pfe/Makefile; fi; fi)
PFE_PACKAGE_VERSION:=$(shell (grep "PKG_VERSION:" $(PFE_PKG_PATH) | cut -d'=' -f 2))
PFE_PACKAGE_RELEASE:=$(shell (grep "PKG_RELEASE:" $(PFE_PKG_PATH) | cut -d'=' -f 2))

PFE_BUILD_DIR=pfe-$(PFE_PACKAGE_VERSION).$(PFE_PACKAGE_RELEASE)
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).tar.gz
PKG_CAT:=zcat
PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_SOURCE)

include $(INCLUDE_DIR)/package.mk

define KernelPackage/pfe_ctrl
  SECTION:=Freescale Packages
  CATEGORY:=Freescale Packages
  TITLE:=PFE control path
  URL:=http://www.freescale.com/
  PKG_BUILD_DEPENDS:=+pfe
  FILES:= $(PKG_BUILD_DIR)/pfe.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/pfe_ctrl/description
 PFE control path.
endef

LRO_MODE:=0
TX_QOS:=0
VWD_TX_OFLD:=0
ifeq ($(CONFIG_TARGET_comcerto2000_nas),y)
	LRO_MODE:=1
	TX_QOS:=1
	VWD_TX_OFLD:=1
endif
ifeq ($(CONFIG_TARGET_comcerto2000_hgw_nas),y)
	LRO_MODE:=2
	TX_QOS:=1
	VWD_TX_OFLD:=2
endif

#If Development, we should download the version from our GIT instead of doing the generic process
ifeq ($(CONFIG_DEV_PFE_CTRL), y)
ifeq ($(CONFIG_DEV_PFE_CTRL_GITBRANCH), "")
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_PFE_CTRL_GITTREE) pfe_ctrl-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_PFE_CTRL_GITTREE) pfe_ctrl-$(PKG_VERSION).$(PKG_RELEASE) && \
	pushd "pfe_ctrl-$(PKG_VERSION).$(PKG_RELEASE)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_PFE_CTRL_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_PFE_CTRL_GITBRANCH) $(CONFIG_DEV_PFE_CTRL_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_PFE_CTRL_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_PFE_CTRL_GITBRANCH) origin/$(CONFIG_DEV_PFE_CTRL_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_PFE_CTRL_GITBRANCH)\""; \
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

define Build/Compile
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KERNELDIR="$(LINUX_DIR)" \
		PFE_DIR="../$(PFE_BUILD_DIR)" \
		DESTDIR="$(PKG_INSTALL_DIR)" all 
endef

define KernelPackage/pfe_ctrl/install
	mkdir -p $(1)/etc/modules.d
	echo pfe lro_mode=$(LRO_MODE) tx_qos=$(TX_QOS) vwd_ofld=$(VWD_TX_OFLD) > $(1)/etc/modules.d/01-pfe
endef

$(eval $(call KernelPackage,pfe_ctrl))
