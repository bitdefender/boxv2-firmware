# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-markupsafe
PKG_VERSION:=0.23
PKG_RELEASE:=1

PKG_SOURCE:=MarkupSafe-0.23.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/M/MarkupSafe/
PKG_MD5SUM:=f5ab3deee4c37cd6a922fb81e730da6e
PKG_BUILD_DIR:=$(BUILD_DIR)/MarkupSafe-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-markupsafe
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Implements a XML/HTML/XHTML Markup safe string for Python
  URL:=http://github.com/mitsuhiko/markupsafe
  DEPENDS:=+python3
endef

define Package/python3-markupsafe/description
 MarkupSafe
 Implements a unicode subclass that supports HTML strings:
 gtgtgt from markupsafe import Markup escape
 gtgtgt escapequotltscriptgtalertdocument.cookielt/scriptgtquot
 Markupuampltscriptampgtalertdocument.cookieamplt/scriptampgt
 gtgtgt tmpl  Markupquotltemgtslt/emgtquot
 gtgtgt tmpl  quotPeter gt Lustigquot
 MarkupultemgtPeter ampgt Lustiglt/emgt
 If you want to make an object unicode that is not yet unicode
 but dont want to lose the taint information you can use the
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

define Package/python3-markupsafe/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-markupsafe))
