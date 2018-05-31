include $(TOPDIR)/rules.mk

PKG_NAME:=dpa_app
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).tar.gz
PKG_CAT:=zcat

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install
PKG_BUILD_DEPENDS:=+fmlib

include $(INCLUDE_DIR)/package.mk

define Package/dpa_app
 SECTION:= Freescale Packages
  CATEGORY:=Freescale Packages
  TITLE:=dpa app 
  URL:=http://www.freescale.com/
  DEPENDS:=+libxml2 +libstdcpp +fmc +usdpaa +cdx +libcli +USE_UCLIBC:libpthread
endef

define Package/dpa_app/Description
  dpaapp application
endef

#If Development, we should downlaod the version from our GIT instead of doing the generic process
ifeq ($(CONFIG_DEV_DPAAPP), y)

ifeq ($(CONFIG_DEV_DPAAPP_GITBRANCH), "")
define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_DPAAPP_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef

else

define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_DPAAPP_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	pushd "$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_DPAAPP_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_DPAAPP_GITBRANCH) $(CONFIG_DEV_DPAAPP_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_DPAAPP_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_DPAAPP_GITBRANCH) origin/$(CONFIG_DEV_DPAAPP_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_DPAAPP_GITBRANCH)\""; \
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

TARGET_CFLAGS += -DENDIAN_LITTLE
TARGET_CFLAGS += -DNCSW_LINUX
TARGET_CFLAGS += -DLS1043
TARGET_CFLAGS += -Os -Wall -Werror 
TARGET_CFLAGS += \
	-I$(STAGING_DIR)/usr/include/fmlib/fmd \
	-I$(STAGING_DIR)/usr/include/fmlib/fmd/integrations \
	-I$(STAGING_DIR)/usr/include/fmlib/fmd/Peripherals \
	-I$(STAGING_DIR)/usr/include/fmc \
	-I$(STAGING_DIR)/usr/include/usdpaa \
	-I$(STAGING_DIR)/usr/include/cdx 

TARGET_LDFLAGS += -lstdc++
TARGET_LDFLAGS += -lxml2 -lfm-arm64a53 -lfmc

define Package/dpa_app/install
	$(CP) $(PKG_BUILD_DIR)/files/etc $(1)/
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_BUILD_DIR)/dpa_app $(1)/usr/bin/
endef

$(eval $(call BuildPackage,dpa_app))
