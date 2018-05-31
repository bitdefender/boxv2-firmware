# 
# Copyright (C) 2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=cmm
PKG_VERSION:=5.07
PKG_RELEASE:=2

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).tar.gz
PKG_CAT:=zcat

include $(INCLUDE_DIR)/package.mk

define Package/cmm
  CATEGORY:=Freescale Packages
  DEFAULT:=n
  DEPENDS:=+kmod-fci +libnetfilter-conntrack +ip +libcli +kmod-nfnetlink +kmod-nf-conntrack-netlink +libpcap +USE_UCLIBC:libpthread
  TITLE:=Conntrack Monitor For Fast Forward
  URL:=http://www.freescale.com/
endef

define Package/cmm/description
 This package is the Conntrack Monitor Application, that manages the Forward Engine tables throught the FCI module.
endef

#If Development, we should downlaod the version from our GIT instead of doing the generic process
ifeq ($(CONFIG_DEV_CMM), y)

ifeq ($(CONFIG_DEV_CMM_GITBRANCH), "")
define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_CMM_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef

else
define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	git clone -b $(CONFIG_DEV_CMM_GITBRANCH) ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_CMM_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(PATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef

endif
endif


PKG_BUILD_DEPENDS:=libnetfilter-conntrack kmod-fci ip libcli libpcap PACKAGE_kmod-auto_bridge:kmod-auto_bridge



define Build/Configure
$(call Build/Configure/Default, )
endef

ifeq ($(CONFIG_TARGET_comcerto2000), y)
EXTRA_CFLAGS+=-DCOMCERTO_2000 -Wno-error -DARCH_ARM32
endif

ifeq ($(CONFIG_TARGET_ls1043a), y)
EXTRA_CFLAGS+=-Wno-error -DLS1043 -DIPSEC_SUPPORT_DISABLED
endif

ifeq ($(CONFIG_WIFI_RTBR_OFFLOAD), y)
EXTRA_CFLAGS+=-DWIFI_ENABLE
endif

ifeq ($(CONFIG_PACKAGE_kmod-auto_bridge), y)
EXTRA_CFLAGS+=-DAUTO_BRIDGE
endif

ifeq ($(CONFIG_PACKAGE_kmod-epavis-dpi),y)
EXTRA_CFLAGS+=-DC2000_DPI
endif

define Build/Compile
	$(call Build/Compile/Default,)
endef


define Package/cmm/install
	$(call Build/Compile/Default, DESTDIR="$(1)" install)
	$(CP) ./files/etc $(1)/
ifeq ($(CONFIG_WIFI_RTBR_OFFLOAD), y)
	cat  ./files/wifi_fastforward_conf_file >>$(1)/etc/config/fastforward
	install -m0755  ./files/wifi_cmm.init $(1)/etc/init.d/cmm
endif
ifeq ($(CONFIG_TARGET_comcerto2000_hgw_nas),y)
	cat ./files/tcp_lro_conf_file >> $(1)/etc/config/fastforward
endif
	$(CP) ./files/bin $(1)/
	$(CP) $(PKG_BUILD_DIR)/src/libcmm.h $(STAGING_DIR)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/cmmd.h $(STAGING_DIR)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/fpp.h $(STAGING_DIR)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/.libs/*.so* $(STAGING_DIR)/usr/lib/
endef


$(eval $(call BuildPackage,cmm))
