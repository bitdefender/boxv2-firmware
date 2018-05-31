# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-pymongo
PKG_VERSION:=2.7.2
PKG_RELEASE:=1

PKG_SOURCE:=pymongo-2.7.2.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/p/pymongo/
PKG_MD5SUM:=bbd229fe0ff43ee130eed9ffa9db7353
PKG_BUILD_DIR:=$(BUILD_DIR)/pymongo-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-pymongo
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Python driver for MongoDB <http://www.mongodb.org>
  URL:=http://github.com/mongodb/mongo-python-driver
  DEPENDS:=+python3
endef

define Package/python3-pymongo/description
 PyMongo
 Info:See the mongo site for more information. See github for the latest source.
 Author:
 Mike Dirolf
 Maintainer:Bernie Hackett ltbernie64mongodb.comgt
 About
 The PyMongo distribution contains tools for interacting with MongoDB
 database from Python.  The bson package is an implementation of
 the BSON format for Python. The pymongo
 package is a native Python driver for MongoDB. The gridfs package
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

define Package/python3-pymongo/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-pymongo))
