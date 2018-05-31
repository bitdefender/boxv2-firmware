# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cma
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/cma-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz

include $(INCLUDE_DIR)/package.mk

define Package/cma
  SUBMENU:=Configuration Management Layer
  SECTION:=admin
  CATEGORY:=Administration
  TITLE:=CMA (Configuration Management Layer API) 
endef

define Package/cma/description
	Configuration Management Layer API Used for TR-069 Support in CPE.
endef

ifeq ($(CONFIG_DEV_CMA_TR069), y)

ifeq ($(CONFIG_DEV_CMA_TR069_CVSBRANCH), "")
define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	cvs -z9 -d:pserver:$(CONFIG_ACTIVEDEV_CVSUSERNAME)@$(CONFIG_ACTIVEDEV_CVSROOTPATH) checkout -d $(PKG_NAME)-$(PKG_VERSION) $(CONFIG_DEV_CMA_TR069_MODULENAME) && \
	popd
endef

else
define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	cvs -z9 -d:pserver:$(CONFIG_ACTIVEDEV_CVSUSERNAME)@$(CONFIG_ACTIVEDEV_CVSROOTPATH) checkout -d $(PKG_NAME)-$(PKG_VERSION) -r $(CONFIG_DEV_CMA_TR069_CVSBRANCH) $(CONFIG_DEV_CMA_TR069_MODULENAME) &&\
	popd
endef

endif
endif

MAKE_FLAGS += \
	all 

TARGET_CFLAGS += -I$(STAGING_DIR)/usr/include
TARGET_LDFLAGS += -L$(STAGING_DIR)/usr/lib

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/src \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"
endef

define Package/cma/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/libcma.a $(STAGING_DIR)/usr/lib/
endef

$(eval $(call BuildPackage,cma))
