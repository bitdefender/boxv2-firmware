# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-simplejson
PKG_VERSION:=3.6.3
PKG_RELEASE:=1

PKG_SOURCE:=simplejson-3.6.3.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/s/simplejson/
PKG_MD5SUM:=bbb654c2d9b5e3c176af1a22522a458f
PKG_BUILD_DIR:=$(BUILD_DIR)/simplejson-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-simplejson
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Simple, fast, extensible JSON encoder/decoder for Python
  URL:=http://github.com/simplejson/simplejson
  DEPENDS:=+python3
endef

define Package/python3-simplejson/description
 simplejson is a simple fast complete correct and extensible
 JSON lthttp://json.orggt encoder and decoder for Python 2.5
 and Python 3.3.  It is pure Python code with no dependencies
 but includes an optional C extension for a serious speed boost.
 The latest documentation for simplejson can be read online here:
 http://simplejson.readthedocs.org/
 simplejson is the externally maintained development version of the
 json library included with Python 2.6 and Python 3.0 but maintains
 backwards compatibility with Python 2.5.
 The encoder can be specialized to provide serialization in any kind of
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

define Package/python3-simplejson/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-simplejson))
