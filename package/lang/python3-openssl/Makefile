# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-openssl
PKG_VERSION:=0.14
PKG_RELEASE:=1

PKG_SOURCE:=pyOpenSSL-0.14.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/p/pyOpenSSL/
PKG_MD5SUM:=8579ff3a1d858858acfba5f046a4ddf7
PKG_BUILD_DIR:=$(BUILD_DIR)/pyOpenSSL-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-openssl
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Python wrapper module around the OpenSSL library
  URL:=https://github.com/pyca/pyopenssl
  DEPENDS:=+python3 +libopenssl
endef

define Package/python3-openssl/description
 High-level wrapper around a subset of the OpenSSL library includes
 SSL.Connection objects wrapping the methods of Pythons portable
 sockets
 Callbacks written in Python
 Extensive error-handling mechanism mirroring OpenSSLs error codes
 System Message: WARNING/2 ltstringgt line 6
 Definition list ends without a blank line unexpected unindent.
 ...  and much more 
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

define Package/python3-openssl/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-openssl))
