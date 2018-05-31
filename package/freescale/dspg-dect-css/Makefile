#
# Copyright (C) 2012 Mindspeed
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dspg-dect-css
PKG_VERSION:=5.00
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/${PKG_NAME}-$(PKG_VERSION).${PKG_RELEASE}
PKG_SOURCE:=${PKG_NAME}-${PKG_VERSION}.${PKG_RELEASE}.tar.gz
PKG_CAT:=zcat

PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

#include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk

define Package/dspg-dect-css/Default
  TITLE:=DSPG DECT CSS
  URL:=http://www.dspg.com/
  CATEGORY:=IP-PBX
endef

define Package/dspg-dect-css
  $(call Package/dspg-dect-css/Default)
  DEFAULT:=y
  MAINTAINER:=DSPG
  MENU:=1
endef

define Package/dspg-dect-css/description
	Support for DSPG DECT CSS device
endef

#define Package/dspg-dect-css/config
#	source "$(SOURCE)/Config.in"
#	$(call Package/$(PKG_NAME)/override_source_path)
#endef

ifneq ($(CONFIG_dspg-dect-css_USE_CUSTOM_SOURCE_DIR),y)

#If Development, we should download the version from our GIT instead of doing the generic process
ifeq ($(CONFIG_DEV_DSPG_DECT_CSS), y)
ifeq ($(CONFIG_DEV_DSPG_DECT_CSS_GITBRANCH), "")
define Build/Prepare
	pushd "$(PKG_BUILD_DIR)/.." && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_DSPG_DECT_CSS_GITTREE) dspg-dect-css-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	pushd "$(PKG_BUILD_DIR)/.." && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_DSPG_DECT_CSS_GITTREE) dspg-dect-css-$(PKG_VERSION).$(PKG_RELEASE) && \
	pushd "dspg-dect-css-$(PKG_VERSION).$(PKG_RELEASE)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_DSPG_DECT_CSS_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_DSPG_DECT_CSS_GITBRANCH) $(CONFIG_DEV_DSPG_DECT_CSS_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_DSPG_DECT_CSS_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_DSPG_DECT_CSS_GITBRANCH) origin/$(CONFIG_DEV_DSPG_DECT_CSS_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_DSPG_DECT_CSS_GITBRANCH)\""; \
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

endif

define Build/Compile
	mkdir -p $(PKG_INSTALL_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR)/tools/osl/linux TARGET_CROSS=$(TARGET_CROSS) LINUX_DIR=$(LINUX_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR)/tools/libcoma-api/linux TARGET_CROSS=$(TARGET_CROSS) LINUX_DIR=$(LINUX_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR)/tools/coma-debug/linux TARGET_CROSS=$(TARGET_CROSS) LINUX_DIR=$(LINUX_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR)/tools/cmbs/test/ TARGET_CROSS=$(TARGET_CROSS) LINUX_DIR=$(LINUX_DIR)
	$(MAKE) -C "$(LINUX_DIR)" SUBDIRS="$(PKG_BUILD_DIR)/css" ARCH="$(LINUX_KARCH)" CROSS_COMPILE="$(TARGET_CROSS)" EXTRA_CFLAGS="-I$(PKG_BUILD_DIR)/css" PREFIX="$(PKG_INSTALL_DIR)" modules
	$(CP) $(PKG_BUILD_DIR)/tools/osl/linux/libOsWrapperLite.so* $(PKG_INSTALL_DIR)
	$(CP) $(PKG_BUILD_DIR)/tools/libcoma-api/linux/libcoma-api.so* $(PKG_INSTALL_DIR)
	$(CP) $(PKG_BUILD_DIR)/tools/cmbs/lib/libcmbs_host_lnx.so* $(PKG_INSTALL_DIR)
	$(CP) $(PKG_BUILD_DIR)/tools/coma-debug/linux/coma-debug $(PKG_INSTALL_DIR)
	$(CP) $(PKG_BUILD_DIR)/tools/cmbs/test/testout/cmbs_tcx $(PKG_INSTALL_DIR)
	$(CP) $(PKG_BUILD_DIR)/css/dspg_dect.$(LINUX_KMOD_SUFFIX) $(PKG_INSTALL_DIR)
endef
	

define Build/InstallDev
	install -d -m0755 $(STAGING_DIR)/usr/lib
	install -d -m0755 $(STAGING_DIR)/usr/include
	$(CP) $(PKG_BUILD_DIR)/tools/osl/linux/libOsWrapperLite.so* $(STAGING_DIR)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/tools/libcoma-api/linux/libcoma-api.so* $(STAGING_DIR)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/tools/cmbs/lib/libcmbs_host_lnx.so* $(STAGING_DIR)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/tools/cmbs/cmbs/cmbs_*.h $(STAGING_DIR)/usr/include
	$(CP) $(PKG_BUILD_DIR)/tools/cmbs/frame/cfr_*.h $(STAGING_DIR)/usr/include
endef

define Build/UninstallDev
	$(RM) $(STAGING_DIR)/usr/lib/libOsWrapperLite.so*
	$(RM) $(STAGING_DIR)/usr/lib/libcoma-api.so*
	$(RM) $(STAGING_DIR)/usr/lib/libcmbs_host_lnx.so*
	$(RM) $(STAGING_DIR)/usr/include/cmbs_*.h
	$(RM) $(STAGING_DIR)/usr/include/cfr_*.h
endef

define Package/dspg-dect-css/install
	mkdir -p $(1)/usr/lib
	mkdir -p $(1)/usr/bin
	mkdir -p $(1)/usr/share/dspg
	$(CP) -d $(PKG_INSTALL_DIR)/coma-debug $(1)/usr/bin
	$(CP) -d $(PKG_INSTALL_DIR)/cmbs_tcx $(1)/usr/share/dspg
	$(CP) -d $(PKG_INSTALL_DIR)/lib*.so* $(1)/usr/lib
	touch $(1)/usr/lib/libdspg_dect.so
	$(CP) ./files/usr $(1)/
	$(CP) ./files/etc $(1)/
	mkdir -p $(1)/lib/modules/$(LINUX_VERSION)
	$(CP) $(PKG_INSTALL_DIR)/dspg_dect.$(LINUX_KMOD_SUFFIX) $(1)/lib/modules/$(LINUX_VERSION)/
	$(CP) ./files/lib $(1)/
endef

$(eval $(call BuildPackage,dspg-dect-css))
