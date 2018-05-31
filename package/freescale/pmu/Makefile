# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=pmu
PKG_VERSION:=4.00
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).tar.gz
PKG_CAT:=zcat
PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_SOURCE)

include $(INCLUDE_DIR)/package.mk

define Package/pmu
  SECTION:=Freescale Packages
  CATEGORY:=Freescale Packages
  TITLE:=pmu firmware
  URL:=http://www.freescale.com/
endef

define Package/pmu/description
 PMU Firmware.
endef

ifneq ($(CONFIG_TARGET_comcerto2000_hgw_c2kmfcnevm)$(CONFIG_TARGET_comcerto2000_nas_c2kmfcnevm)$(CONFIG_TARGET_comcerto2000_hgw_nas_c2kmfcnevm)$(CONFIG_TARGET_comcerto2000_hgw_boxv2),)
        PMU_PMIC_FLAG="-DCONFIG_ENABLE_PMIC_PMU"
endif

#If Development, we should download the version from our GIT instead of doing the generic process
ifeq ($(CONFIG_DEV_PMU), y)
ifeq ($(CONFIG_DEV_PMU_GITBRANCH), "")
define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_PMU_GITTREE) pmu-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_PMU_GITTREE) pmu-$(PKG_VERSION).$(PKG_RELEASE) && \
	pushd "pmu-$(PKG_VERSION).$(PKG_RELEASE)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_PMU_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_PMU_GITBRANCH) $(CONFIG_DEV_PMU_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_PMU_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_PMU_GITBRANCH) origin/$(CONFIG_DEV_PMU_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_PMU_GITBRANCH)\""; \
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
        TOOL_PATH_GCC=$(TOOLCHAIN_DIR) FLAG=$(PMU_PMIC_FLAG)
endef

define Package/pmu/install
	mkdir -p $(1)/lib/firmware
	$(CP) -a $(PKG_BUILD_DIR)/pmuboot/pmu.elf $(1)/lib/firmware/
endef

$(eval $(call BuildPackage,pmu))
