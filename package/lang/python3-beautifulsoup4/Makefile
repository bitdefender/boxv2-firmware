# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-beautifulsoup4
PKG_VERSION:=4.5.1
PKG_RELEASE:=1

PKG_SOURCE:=beautifulsoup4-4.5.1.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/86/ea/8e9fbce5c8405b9614f1fd304f7109d9169a3516a493ce4f7f77c39435b7/
PKG_MD5SUM:=994abd90e691beaf7d42c00ffb2f3a67
PKG_BUILD_DIR:=$(BUILD_DIR)/beautifulsoup4-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-beautifulsoup4

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-beautifulsoup4
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=beautifulsoup4
  URL:=https://pypi.python.org/pypi/beautifulsoup4
  DEPENDS:=+python3 +python3-setuptools
endef

define Package/python3-peewee/description
 Peewee is a simple and small ORM. It has few (but expressive) concepts,
 making it easy to learn and intuitive to use.
endef

define Build/Compile
	$(call Build/Compile/PyMod,., \
		install --prefix="/usr" --root="$(PKG_INSTALL_DIR)" \
	)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(STAGING_DIR)$(PYTHON_PKG_DIR)/
	[ ! -e $(PKG_INSTALL_DIR)/usr/include ] || $(CP) \
		$(PKG_INSTALL_DIR)/usr/include/* \
		$(STAGING_DIR)/usr/include/
endef

define Package/python3-beautifulsoup4/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-beautifulsoup4))
