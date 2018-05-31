include $(TOPDIR)/rules.mk

PKG_NAME:=usdpaa
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz

include $(INCLUDE_DIR)/package.mk

define Package/usdpaa
  SECTION:= Freescale Packages
  CATEGORY:=Freescale Packages
  TITLE:=usdpaa libraries
  DEPENDS:=@TARGET_ls1043a
  DEFAULT:=y if TARGET_ls1043a
  URL:=http://www.freescale.com/
endef

define Package/usdpaa/Description
  usdpaa library
endef

TARGET_CFLAGS += -I $(PKG_BUILD_DIR)/include -DCONFIG_ARM64
define Build/Compile
        $(MAKE) -C $(PKG_BUILD_DIR) \
                DESTDIR="$(PKG_INSTALL_DIR)" \
                CC="$(TARGET_CC)" \
                GCC="$(TARGET_CC)" \
                CFLAGS="$(TARGET_CFLAGS)" \
                LDFLAGS="$(TARGET_LDFLAGS)"
endef


define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/*.a $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/include/usdpaa
	$(CP) $(PKG_BUILD_DIR)/include/* $(1)/usr/include/usdpaa
endef

$(eval $(call BuildPackage,usdpaa))
