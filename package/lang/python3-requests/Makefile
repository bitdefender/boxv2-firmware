# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-requests
PKG_VERSION:=2.4.1
PKG_RELEASE:=1

PKG_SOURCE:=requests-2.4.1.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/r/requests/
PKG_MD5SUM:=931461f761c70708c46ea65b7889da58
PKG_BUILD_DIR:=$(BUILD_DIR)/requests-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-requests
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Python HTTP for Humans.
  URL:=http://python-requests.org
  DEPENDS:=+python3 +python3-urllib3
endef

define Package/python3-requests/description
 Requests: HTTP for Humans
 Requests is an Apache2 Licensed HTTP library written in Python for human
 beings.
 Most existing Python modules for sending HTTP requests are extremely
 verbose and cumbersome. Pythons builtin urllib2 module provides most of
 the HTTP capabilities you should need but the api is thoroughly broken.
 It requires an enormous amount of work even method overrides to
 perform the simplest of tasks.
 Things shouldnt be this way. Not in Python.
 gtgtgt r  requests.gethttps://api.github.com authuser pass
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

define Package/python3-requests/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-requests))
