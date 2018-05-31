# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-crypto
PKG_VERSION:=2.6.1
PKG_RELEASE:=1

PKG_SOURCE:=pycrypto-2.6.1.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/p/pycrypto/
PKG_MD5SUM:=55a61a054aa66812daf5161a0d5d7eda
PKG_BUILD_DIR:=$(BUILD_DIR)/pycrypto-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-crypto
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Cryptographic modules for Python.
  URL:=http://www.pycrypto.org/
  DEPENDS:=+python3 +libgmp
endef

define Package/python3-crypto/description
 Python Cryptography Toolkit pycrypto
 This is a collection of both secure hash functions such as SHA256 and
 RIPEMD160 and various encryption algorithms AES DES RSA ElGamal
 etc..  The package is structured to make adding new modules easy.
 This section is essentially complete and the software interface will
 almost certainly not change in an incompatible way in the future all
 that remains to be done is to fix any bugs that show up.  If you
 encounter a bug please report it in the Launchpad bug tracker at
 https://launchpad.net/products/pycrypto/bugs
 An example usage of the SHA256 module is:
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

define Package/python3-crypto/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-crypto))
