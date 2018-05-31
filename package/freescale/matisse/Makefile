# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: Makefile,v 1.1.1.1 2006/07/18 09:55:10 silvano.dininno Exp $

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=matisse
PKG_VERSION:=10.00
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)
#PKG_SOURCE_URL:=http://10.1.124.219/cpe_group/openwrt/download-phase3
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).tar.gz
PKG_CAT:=zcat

PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/package.mk
SUPPORT_SLIC:=no
SUPPORT_DSPG_DECT:=no
DSPG_DECT_SPI_MODE:=no
DSPG_DECT_COMA_MODE:=no

ifeq ($(CONFIG_PACKAGE_dspg-dect-css), y)
	SUPPORT_DSPG_DECT:=yes
	DSPG_DECT_COMA_MODE:=yes
endif

#If there is SLIC driver, activate feature on Matisse
ifeq ($(CONFIG_PACKAGE_kmod-legerity), y)
	SUPPORT_SLIC:=yes
else
ifeq ($(CONFIG_PACKAGE_kmod-si3215), y)
	SUPPORT_SLIC:=yes
else
ifeq ($(CONFIG_PACKAGE_kmod-proslic), y)
	SUPPORT_SLIC:=yes
endif
endif
endif

ifeq ($(CONFIG_TARGET_comcerto1000),y)
	TARGET_NODE:=m83xxx0
else
	TARGET_NODE:=m821xx0
endif

define Package/matisse/Default
  CATEGORY:=Freescale Packages
  URL:=http://www.freescale.com/
  DEPENDS:=+msp-firmware
endef

PKG_BUILD_DEPENDS:=libtool argp-standalone PACKAGE_dspg-dect-css:dspg-dect-css

define Package/matisse/Default/Description
  Matisse is a set of modules to control MSP (Maestro) and SLIC devices (Tempo).
endef

define Package/kmod-matisse
  $(call Package/matisse/Default)
  TITLE:=Matisse kernel modules
  MENU:=1
endef

define Package/Maestro
  $(call Package/matisse/Default)
  DEPENDS:=kmod-matisse
  TITLE:=Maestro driver 
  DEFAULT:=n
endef

define Package/Maestro/Description
  Maestro driver controls MSP.
endef

define Package/Tempo
  $(call Package/matisse/Default)
  DEPENDS:=+kmod-matisse +PACKAGE_dspg-dect-css:dspg-dect-css
  TITLE:=Tempo driver 
  DEFAULT:=n
endef

define Package/Tempo/Description
  Tempo driver controls SLICS and other periferal (telephony).
endef

#If Development, we should download the version from GIT instead of doing the generic process
ifeq ($(CONFIG_DEV_MATISSE), y)
ifeq ($(CONFIG_DEV_MATISSE_GITBRANCH), "")
define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_MATISSE_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \ 
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_MATISSE_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	pushd "$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_MATISSE_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_MATISSE_GITBRANCH) $(CONFIG_DEV_MATISSE_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_MATISSE_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_MATISSE_GITBRANCH) origin/$(CONFIG_DEV_MATISSE_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_MATISSE_GITBRANCH)\""; \
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

#C_FLAGS=-DDEBUG_MSG
TARGET_CPPFLAGS+=-DTEMPO_NEW_API
CPP_FLAGS=$(TARGET_CPPFLAGS) $(TARGET_LDFLAGS)

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
			$(TARGET_CONFIGURE_OPTS) \
			KERNEL_SOURCE="$(LINUX_DIR)" \
			ARCH="$(LINUX_KARCH)" \
			CROSS_COMPILE="$(TARGET_CROSS)" \
			ROOT_PREFIX="$(PKG_INSTALL_DIR)" \
			EXTRA_CFLAGS=$(C_FLAGS) \
			APPS_CFLAGS="$(CPP_FLAGS)" \
			PACKAGE=common \
			SUPPORT_SLIC=$(SUPPORT_SLIC) \
			all
	$(MAKE) -C $(PKG_BUILD_DIR) \
			$(TARGET_CONFIGURE_OPTS) \
			KERNEL_SOURCE="$(LINUX_DIR)" \
			ARCH="$(LINUX_KARCH)" \
			CROSS_COMPILE="$(TARGET_CROSS)" \
			ROOT_PREFIX="$(PKG_INSTALL_DIR)" \
			EXTRA_CFLAGS=$(C_FLAGS) \
			APPS_CFLAGS="$(CPP_FLAGS)" \
			PACKAGE=common \
			SUPPORT_SLIC=$(SUPPORT_SLIC) \
			install
ifeq ($(CONFIG_PACKAGE_Maestro),y)
	$(MAKE) -C $(PKG_BUILD_DIR) \
			$(TARGET_CONFIGURE_OPTS) \
			KERNEL_SOURCE="$(LINUX_DIR)" \
			ARCH="$(LINUX_KARCH)" \
			CROSS_COMPILE="$(TARGET_CROSS)" \
			ROOT_PREFIX="$(PKG_INSTALL_DIR)" \
			EXTRA_CFLAGS=$(C_FLAGS) \
			APPS_CFLAGS="$(CPP_FLAGS)" \
			PACKAGE=maestro \
			SUPPORT_SLIC=$(SUPPORT_SLIC) \
			all
	$(MAKE) -C $(PKG_BUILD_DIR) \
			$(TARGET_CONFIGURE_OPTS) \
			KERNEL_SOURCE="$(LINUX_DIR)" \
			ARCH="$(LINUX_KARCH)" \
			CROSS_COMPILE="$(TARGET_CROSS)" \
			ROOT_PREFIX="$(PKG_INSTALL_DIR)" \
			EXTRA_CFLAGS=$(C_FLAGS) \
			APPS_CFLAGS="$(CPP_FLAGS)" \
			PACKAGE=maestro \
			SUPPORT_SLIC=$(SUPPORT_SLIC) \
			install
endif
ifeq ($(CONFIG_PACKAGE_Tempo),y)
	$(MAKE) -C $(PKG_BUILD_DIR) \
			$(TARGET_CONFIGURE_OPTS) \
			KERNEL_SOURCE="$(LINUX_DIR)" \
			ARCH="$(LINUX_KARCH)" \
			CROSS_COMPILE="$(TARGET_CROSS)" \
			ROOT_PREFIX="$(PKG_INSTALL_DIR)" \
			EXTRA_CFLAGS=$(C_FLAGS) \
			APPS_CFLAGS="$(CPP_FLAGS)" \
			PACKAGE=tempo \
			SUPPORT_SLIC=$(SUPPORT_SLIC) \
			SUPPORT_BT8370_PRI=no \
			SUPPORT_DSPG_DECT=$(SUPPORT_DSPG_DECT) \
			DSPG_DECT_SPI_MODE=$(DSPG_DECT_SPI_MODE) \
			DSPG_DECT_COMA_MODE=$(DSPG_DECT_COMA_MODE) \
			all
	$(MAKE) -C $(PKG_BUILD_DIR) \
			$(TARGET_CONFIGURE_OPTS) \
			KERNEL_SOURCE="$(LINUX_DIR)" \
			ARCH="$(LINUX_KARCH)" \
			CROSS_COMPILE="$(TARGET_CROSS)" \
			ROOT_PREFIX="$(PKG_INSTALL_DIR)" \
			EXTRA_CFLAGS=$(C_FLAGS) \
			APPS_CFLAGS="$(CPP_FLAGS)" \
			PACKAGE=tempo \
			SUPPORT_SLIC=$(SUPPORT_SLIC) \
			SUPPORT_BT8370_PRI=no \
			SUPPORT_DSPG_DECT=$(SUPPORT_DSPG_DECT) \
			DSPG_DECT_SPI_MODE=$(DSPG_DECT_SPI_MODE) \
			DSPG_DECT_COMA_MODE=$(DSPG_DECT_COMA_MODE) \
			install
endif
	mkdir -p $(STAGING_DIR)/usr/lib
	$(CP) -a $(PKG_INSTALL_DIR)/usr/lib/*.so* $(STAGING_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/include/
	$(CP) -a $(PKG_INSTALL_DIR)/usr/include/* $(STAGING_DIR)/usr/include/
	mkdir -p $(STAGING_DIR)/usr/include/common
	$(CP) -a $(PKG_BUILD_DIR)/common/include/* $(STAGING_DIR)/usr/include/common/
endef


define Build/InstallDev
endef

define Build/UninstallDev
endef

define Package/kmod-matisse/install
	mkdir -p $(1)/lib/modules/$(LINUX_VERSION)
	mkdir -p $(1)/usr/bin
	mkdir -p $(1)/usr/lib
	mkdir -p $(1)/dev
	mkdir -p $(1)/usr/local/etc
	$(CP) -a $(PKG_INSTALL_DIR)/lib/modules/*/extra/* $(1)/lib/modules/$(LINUX_VERSION)/
	$(CP) -a ./files/usr $(1)/
	$(CP) -a ./files/etc $(1)/

	$(CP) $(PKG_BUILD_DIR)/wan/include/slic_itf.h $(STAGING_DIR)/usr/include
endef

define Package/Tempo/install
	mkdir -p $(1)/usr/bin
	mkdir -p $(1)/usr/lib
	mkdir -p $(1)/etc/init.d
	$(CP) -a $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin/
	$(CP) -a $(PKG_INSTALL_DIR)/usr/lib/*.so* $(1)/usr/lib/

	install -m0755 ./files/tempo-slic $(1)/etc/init.d/tempo-slic
endef

define Package/Maestro/install
	# --== ASTERISK with VAPI based MSPD channel module ==--
	# Making Matisse not bootable
	sed -i 's/START=/#START=/' $(1)/etc/init.d/matisse 
endef

$(eval $(call BuildPackage,Maestro))
$(eval $(call BuildPackage,Tempo))
$(eval $(call BuildPackage,kmod-matisse))
