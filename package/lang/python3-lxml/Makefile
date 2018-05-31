# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-lxml
PKG_VERSION:=3.4.0
PKG_RELEASE:=1

PKG_SOURCE:=lxml-3.4.0.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/l/lxml/
PKG_MD5SUM:=bc90cc4e4ee04e1f8290ae0f70e34eea
PKG_BUILD_DIR:=$(BUILD_DIR)/lxml-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-lxml
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Powerful and Pythonic XML processing library combining libxml2/libxslt with the ElementTree API.
  URL:=http://lxml.de/
  DEPENDS:=+python3 +libxml2 +libxslt +libexslt +zlib
endef

define Package/python3-lxml/description
 lxml is a Pythonic mature binding for the libxml2 and libxslt libraries.  It
 provides safe and convenient access to these libraries using the ElementTree
 API.
 It extends the ElementTree API significantly to offer support for XPath
 RelaxNG XML Schema XSLT C14N and much more.
 To contact the project go to the project home page or see our bug tracker at
 https://launchpad.net/lxml
 In case you want to use the current in-development version of lxml
 you can get it from the github repository at
 https://github.com/lxml/lxml .  Note that this requires Cython to
endef

define Build/Compile
	$(call Build/Compile/PyMod,., \
		install --prefix="/usr" --root="$(PKG_INSTALL_DIR)", \
		, \
		"-I$(STAGING_DIR)/usr/include/libxml2" \
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

define Package/python3-lxml/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-lxml))
