# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-httplib2
PKG_VERSION:=0.9
PKG_RELEASE:=1

PKG_SOURCE:=httplib2-0.9.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/h/httplib2/
PKG_MD5SUM:=09d8e8016911fc40e2e4c58f1aa3ec24
PKG_BUILD_DIR:=$(BUILD_DIR)/httplib2-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-httplib2
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=A comprehensive HTTP client library.
  URL:=https://github.com/jcgregorio/httplib2
  DEPENDS:=+python3
endef

define Package/python3-httplib2/description
 A comprehensive HTTP client library httplib2 supports many features left out of other HTTP libraries.
 HTTP and HTTPS
 HTTPS support is only available if the socket module was compiled with SSL support.
 Keep-Alive
 Supports HTTP 1.1 Keep-Alive keeping the socket open and performing multiple requests over the same connection if possible.
 Authentication
 The following three types of HTTP Authentication are supported. These can be used over both HTTP and HTTPS.
 Digest
 Basic
 WSSE
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

define Package/python3-httplib2/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-httplib2))
