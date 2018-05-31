# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-werkzeug
PKG_VERSION:=0.9.6
PKG_RELEASE:=1

PKG_SOURCE:=Werkzeug-0.9.6.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/W/Werkzeug/
PKG_MD5SUM:=f7afcadc03b0f2267bdc156c34586043
PKG_BUILD_DIR:=$(BUILD_DIR)/Werkzeug-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-werkzeug
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=The Swiss Army knife of Python web development
  URL:=http://werkzeug.pocoo.org/
  DEPENDS:=+python3
endef

define Package/python3-werkzeug/description
 Werkzeug
 Werkzeug started as simple collection of various utilities for WSGI
 applications and has become one of the most advanced WSGI utility
 modules.  It includes a powerful debugger full featured request and
 response objects HTTP utilities to handle entity tags cache control
 headers HTTP dates cookie handling file uploads a powerful URL
 routing system and a bunch of community contributed addon modules.
 Werkzeug is unicode aware and doesnt enforce a specific template
 engine database adapter or anything else.  It doesnt even enforce
 a specific way of handling requests and leaves all that up to the
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

define Package/python3-werkzeug/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-werkzeug))
