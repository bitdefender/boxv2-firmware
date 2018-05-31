# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-pip
PKG_VERSION:=1.5.6
PKG_RELEASE:=1

PKG_SOURCE:=pip-1.5.6.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/p/pip/
PKG_MD5SUM:=01026f87978932060cc86c1dc527903e
PKG_BUILD_DIR:=$(BUILD_DIR)/pip-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-pip
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=A tool for installing and managing Python packages.
  URL:=https://pip.pypa.io/
  DEPENDS:=+python3 +python3-setuptools
endef

define Package/python3-pip/description
 Project Info
 Project Page: https://github.com/pypa/pip
 Install howto: https://pip.pypa.io/en/latest/installing.html
 Changelog: https://pip.pypa.io/en/latest/news.html
 Bug Tracking: https://github.com/pypa/pip/issues
 Mailing list: http://groups.google.com/group/python-virtualenv
 Docs: https://pip.pypa.io/
 User IRC: pypa on Freenode.
 Dev IRC: pypa-dev on Freenode.
 Quickstart
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

define Package/python3-pip/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/pip3 \
		$(1)/usr/bin/pip3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/pip3


endef

$(eval $(call BuildPackage,python3-pip))
