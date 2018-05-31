include $(TOPDIR)/rules.mk

PKG_NAME:=jemalloc
PKG_VERSION:=5.0.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/jemalloc/jemalloc/releases/download/${PKG_VERSION}
PKG_MD5SUM:=507f7b6b882d868730d644510491d18f
PKG_LICENSE:=LGPL-2.1

include $(INCLUDE_DIR)/package.mk

define Package/jemalloc
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=jemalloc
  DEPENDS:=+libstdcpp +libgcc
  URL:=https://github.com/jemalloc/jemalloc
endef

define Package/jemalloc/description
 jemalloc
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/lib/libjemalloc* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/include/jemalloc
	$(CP) $(PKG_BUILD_DIR)/include/jemalloc/jemalloc.h $(1)/usr/include/jemalloc/
endef

define Package/jemalloc/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/lib/libjemalloc.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,jemalloc))
