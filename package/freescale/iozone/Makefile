include $(TOPDIR)/rules.mk

PKG_NAME:=iozone
PKG_VERSION:=405
PKG_RELEASE:=0

PKG_SOURCE:=$(PKG_NAME)3_$(PKG_VERSION).tar
PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_NAME)3_$(PKG_VERSION).tar
PKG_SOURCE_URL:=http://www.iozone.org/src/current/

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)3_$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/package.mk

define Package/iozone
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+USE_UCLIBC:librt +USE_UCLIBC:libpthread
  TITLE:=iozone
  URL:=http://www.iozone.org/src/current/
endef

define Package/iozone/Description
  iozone
endef

ifeq ($(CONFIG_USE_UCLIBC),y)
define Build/Prepare
	$(call Build/Prepare/Default,)	
endef
else
define Build/Prepare
	$(TAR) xf $(PKG_SOURCE_FILE) -C $(PKG_BUILD_DIR)/../
endef
endif

define Build/Compile
        $(MAKE) -C $(PKG_BUILD_DIR)/src/current/ \
                DESTDIR="$(PKG_INSTALL_DIR)" \
                CC="$(TARGET_CC)" \
                GCC="$(TARGET_CC)" \
                CFLAGS="$(TARGET_CFLAGS)" \
                LDFLAGS="$(TARGET_LDFLAGS)" linux-arm
endef

define Package/iozone/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_BUILD_DIR)/src/current/iozone $(1)/usr/bin/
endef

$(eval $(call BuildPackage,iozone))
