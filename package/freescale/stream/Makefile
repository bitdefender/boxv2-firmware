include $(TOPDIR)/rules.mk

PKG_NAME:=stream
PKG_VERSION:=0.0
PKG_RELEASE:=0

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.cs.virginia.edu/$(PKG_NAME)/FTP/Code

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/package.mk

define Package/stream
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=stream
  URL:=http://www.cs.virginia.edu/stream/FTP/Code
endef

define Package/stream/Description
  stream
endef

define Build/Compile
        $(MAKE) -C $(PKG_BUILD_DIR) \
                DESTDIR="$(PKG_INSTALL_DIR)" \
                OS="$(TARGET_CROSS)" CC="$(TARGET_CC)"
endef

define Package/stream/install
	$(INSTALL_DIR) $(1)/usr/
	$(INSTALL_DIR) $(1)/usr/local/
	$(INSTALL_DIR) $(1)/usr/local/bin/
	$(CP) $(PKG_BUILD_DIR)/stream_c.exe $(1)/usr/local/bin/
endef

$(eval $(call BuildPackage,stream))
