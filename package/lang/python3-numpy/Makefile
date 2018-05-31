# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-numpy
PKG_VERSION:=1.9.0
PKG_RELEASE:=1

PKG_SOURCE:=numpy-1.9.0.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/n/numpy/
PKG_MD5SUM:=510cee1c6a131e0a9eb759aa2cc62609
PKG_BUILD_DIR:=$(BUILD_DIR)/numpy-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-numpy
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=NumPy: array processing for numbers, strings, records, and objects.
  URL:=http://www.numpy.org
  DEPENDS:=+python3 @BROKEN
endef

define Package/python3-numpy/description
 NumPy is a general-purpose array-processing package designed to
 efficiently manipulate large multi-dimensional arrays of arbitrary
 records without sacrificing too much speed for small multi-dimensional
 arrays.  NumPy is built on the Numeric code base and adds features
 introduced by numarray as well as an extended C-API and the ability to
 create arrays of arbitrary type which also makes NumPy suitable for
 interfacing with general-purpose data-base applications.
 There are also basic facilities for discrete fourier transform
 basic linear algebra and random number generation.
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

define Package/python3-numpy/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-numpy))
