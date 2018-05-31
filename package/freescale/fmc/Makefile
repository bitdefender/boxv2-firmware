include $(TOPDIR)/rules.mk

PKG_NAME:=fmc
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)
PKG_CAT:=zcat
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install
PKG_BUILD_DEPENDS:=+fmlib +libxml2

include $(INCLUDE_DIR)/package.mk

define Package/fmc
  SECTION:=Freescale Packages
  CATEGORY:=Freescale Packages
  TITLE:=fmc library
  URL:=http://www.freescale.com/
endef

define Package/fmc/Description
  fmc library
endef

#If Development, we should downlaod the version from our GIT instead of doing the generic process
ifeq ($(CONFIG_DEV_FMC), y)

ifeq ($(CONFIG_DEV_FMC_GITBRANCH), "")
define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_FMC_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef

else
define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	git clone -b $(CONFIG_DEV_FMC_GITBRANCH) ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_FMC_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(PATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef

endif
endif


FMC_FLAGS = -DENDIAN_LITTLE
FMC_FLAGS += -DNCSW_LINUX
FMC_FLAGS += -DLS1043
FMC_FLAGS += -Os -Wall
FMC_FLAGS +=  \
	-I$(STAGING_DIR)/usr/include/fmlib/fmd \
	-I$(STAGING_DIR)/usr/include/fmlib/fmd/integrations \
	-I$(STAGING_DIR)/usr/include/fmlib/fmd/Peripherals \
	-I$(STAGING_DIR)/usr/include/libxml2

TARGET_LDFLAGS += -lstdc++

TARGET_CFLAGS += $(FMC_FLAGS)
TARGET_CXXFLAGS += $(FMC_FLAGS)


define Package/fmc/install
	$(CP) $(PKG_BUILD_DIR)/etc $(1)/
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/source/*.a $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/include/fmc
	$(CP) $(PKG_BUILD_DIR)/source/fmc.h $(1)/usr/include/fmc
endef

$(eval $(call BuildPackage,fmc))
