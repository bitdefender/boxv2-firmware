# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-dateutil
PKG_VERSION:=2.2
PKG_RELEASE:=1

PKG_SOURCE:=python-dateutil-2.2.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/p/python-dateutil/
PKG_MD5SUM:=c1f654d0ff7e33999380a8ba9783fd5c
PKG_BUILD_DIR:=$(BUILD_DIR)/python-dateutil-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-dateutil
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Extensions to the standard Python datetime module
  URL:=http://labix.org/python-dateutil
  DEPENDS:=+python3
endef

define Package/python3-dateutil/description
 The dateutil module provides powerful extensions to the
 datetime module available in the Python standard library.
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

define Package/python3-dateutil/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-dateutil))
