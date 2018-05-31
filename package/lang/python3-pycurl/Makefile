# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-pycurl
PKG_VERSION:=7.19.5
PKG_RELEASE:=1

PKG_SOURCE:=pycurl-7.19.5.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/p/pycurl/
PKG_MD5SUM:=47b4eac84118e2606658122104e62072
PKG_BUILD_DIR:=$(BUILD_DIR)/pycurl-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-pycurl
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=PycURL -- cURL library module for Python
  URL:=http://pycurl.sourceforge.net/
  DEPENDS:=+python3 +libcurl
endef

define Package/python3-pycurl/description
 This module provides Python bindings for the cURL library.
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

define Package/python3-pycurl/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-pycurl))
