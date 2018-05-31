# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-jinja2
PKG_VERSION:=2.7.3
PKG_RELEASE:=1

PKG_SOURCE:=Jinja2-2.7.3.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/J/Jinja2/
PKG_MD5SUM:=b9dffd2f3b43d673802fe857c8445b1a
PKG_BUILD_DIR:=$(BUILD_DIR)/Jinja2-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-jinja2
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=A small but fast and easy to use stand-alone template engine written in pure python.
  URL:=http://jinja.pocoo.org/
  DEPENDS:=+python3 +python3-markupsafe
endef

define Package/python3-jinja2/description
 Jinja2
 Jinja2 is a template engine written in pure Python.  It provides a
 Django inspired non-XML syntax but supports inline expressions and
 an optional sandboxed environment.
 Nutshell
 Here a small example of a Jinja template:
  extends base.html 
  block title Memberlist endblock 
  block content 
   ltulgt
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

define Package/python3-jinja2/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-jinja2))
