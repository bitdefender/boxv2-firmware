# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-pymysql
PKG_VERSION:=0.6.2
PKG_RELEASE:=1

PKG_SOURCE:=PyMySQL-0.6.2.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/P/PyMySQL/
PKG_MD5SUM:=5d7016e8f13e6c4edb539aa736896ffe
PKG_BUILD_DIR:=$(BUILD_DIR)/PyMySQL-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-pymysql
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Pure-Python MySQL Driver
  URL:=https://github.com/PyMySQL/PyMySQL/
  DEPENDS:=+python3
endef

define Package/python3-pymysql/description
 PyMySQL
 This package contains a pure-Python MySQL client library. The goal of PyMySQL
 is to be a drop-in replacement for MySQLdb and work on CPython PyPy
 IronPython and Jython.
 Requirements
 Python -- one of the following:
 CPython gt 2.6 or gt 3.3
 PyPy gt 2.0
 IronPython 2.7
 MySQL Server -- one of the following:
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

define Package/python3-pymysql/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-pymysql))
