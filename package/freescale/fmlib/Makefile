include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=fmlib
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)
PKG_CAT:=zcat

include $(INCLUDE_DIR)/package.mk

define Package/fmlib
  SECTION:=Freescale Packages
  CATEGORY:=Freescale Packages
  TITLE:=fmc library
  DEPENDS:=@TARGET_ls1043a
  DEFAULT:=y if TARGET_ls1043a
  URL:=http://www.freescale.com/
endef

define Package/fmlib/Description
  fm library
endef

#If Development, we should downlaod the version from our GIT instead of doing the generic process
ifeq ($(CONFIG_DEV_FMLIB), y)

ifeq ($(CONFIG_DEV_FMLIB_GITBRANCH), "")
define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_FMLIB_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef

else
define Build/Prepare
	pushd "$(BUILD_DIR)" && \
	git clone -b $(CONFIG_DEV_FMLIB_GITBRANCH) ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_FMLIB_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(PATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef

endif
endif


TARGET_CFLAGS += -DENDIAN_LITTLE
TARGET_CFLAGS += -Os -Wall -Werror 

ifeq ($(CONFIG_aarch64), y)
	TARGET_ARCH=arm64
else
	TARGET_ARCH=arm
endif

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE="$(TARGET_CROSS)" KERNEL_SRC="$(LINUX_DIR)" ARCH="$(TARGET_ARCH)" 
endef


define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/*.a $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/include/fmlib
	$(CP) $(PKG_BUILD_DIR)/include/* $(1)/usr/include/fmlib/
endef

$(eval $(call BuildPackage,fmlib))
