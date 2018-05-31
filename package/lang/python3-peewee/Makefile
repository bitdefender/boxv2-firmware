# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-peewee
PKG_VERSION:=2.8.5
PKG_RELEASE:=1

PKG_SOURCE:=peewee-2.8.5.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/c1/22/8d6bc2333b6478503ef3a260d20d76f1b814fdb1930ebe195d1a626a5aea/
PKG_MD5SUM:=24c2d2bedca3e423ab10e1b9dc4095b8
PKG_BUILD_DIR:=$(BUILD_DIR)/peewee-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-peewee
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Simple and small ORM
  URL:=https://pypi.python.org/pypi/peewee
  DEPENDS:=+python3
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

define Package/python3-peewee/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-peewee))
