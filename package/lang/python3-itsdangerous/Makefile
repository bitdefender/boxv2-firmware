# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-itsdangerous
PKG_VERSION:=0.24
PKG_RELEASE:=1

PKG_SOURCE:=itsdangerous-0.24.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/i/itsdangerous/
PKG_MD5SUM:=a3d55aa79369aef5345c036a8a26307f
PKG_BUILD_DIR:=$(BUILD_DIR)/itsdangerous-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-itsdangerous
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Various helpers to pass trusted data to untrusted environments and back.
  URL:=http://github.com/mitsuhiko/itsdangerous
  DEPENDS:=+python3
endef

define Package/python3-itsdangerous/description
 Its Dangerous
 ... so better sign this
 Various helpers to pass data to untrusted environments and to get it back
 safe and sound.
 This repository provides a module that is a port of the django signing
 module.  Its not directly copied but some changes were applied to
 make it work better on its own.
 Also I plan to add some extra things.  Work in progress.
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

define Package/python3-itsdangerous/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-itsdangerous))
