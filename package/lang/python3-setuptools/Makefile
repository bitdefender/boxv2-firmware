# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-setuptools
PKG_VERSION:=5.8
PKG_RELEASE:=1

PKG_SOURCE:=setuptools-5.8.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/s/setuptools/
PKG_MD5SUM:=356480fdf03590cfdf4210cf8366bcaf
PKG_BUILD_DIR:=$(BUILD_DIR)/setuptools-$(PKG_VERSION)/

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-setuptools
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Easily download, build, install, upgrade, and uninstall Python packages
  URL:=https://bitbucket.org/pypa/setuptools
  DEPENDS:=+python3
endef

define Package/python3-setuptools/description
 Installing and Using Setuptools
 Installation Instructions
 The recommended way to bootstrap setuptools on any system is to download
 ez_setup.py and run it using the target Python environment. Different
 operating systems have different recommended techniques to accomplish this
 basic routine so below are some examples to get you started.
 Setuptools requires Python 2.6 or later. To install setuptools
 on Python 2.4 or Python 2.5 use the bootstrap script for Setuptools 1.x.
 The link provided to ez_setup.py is a bookmark to bootstrap script for the
 latest known stable release.
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

define Package/python3-setuptools/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/easy_install \
		$(1)/usr/bin/easy_install3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/easy_install3


endef

$(eval $(call BuildPackage,python3-setuptools))
