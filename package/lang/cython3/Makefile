# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cython3
PKG_VERSION:=0.21
PKG_RELEASE:=1

PKG_SOURCE:=Cython-0.21.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/C/Cython/
PKG_MD5SUM:=6c9c4d19ba485fe8cd88e23b57ac7886
PKG_BUILD_DIR:=$(BUILD_DIR)/Cython-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/cython3
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=The Cython compiler for writing C extensions for the Python language.
  URL:=http://www.cython.org
  DEPENDS:=+python3
endef

define Package/cython3/description
 The Cython language makes writing C extensions for the Python language as
 easy as Python itself.  Cython is a source code translator based on the
 well-known Pyrex but supports more cutting edge functionality and
 optimizations.
 The Cython language is very close to the Python language and most Python
 code is also valid Cython code but Cython additionally supports calling C
 functions and declaring C types on variables and class attributes. This
 allows the compiler to generate very efficient C code from Cython code.
 This makes Cython the ideal language for writing glue code for external C
 libraries and for fast C modules that speed up the execution of Python
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

define Package/cython3/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/cython \
		$(1)/usr/bin/cython3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/cython3


endef

$(eval $(call BuildPackage,cython3))
