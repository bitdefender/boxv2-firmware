# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-flask
PKG_VERSION:=0.10.1
PKG_RELEASE:=1

PKG_SOURCE:=Flask-0.10.1.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/F/Flask/
PKG_MD5SUM:=378670fe456957eb3c27ddaef60b2b24
PKG_BUILD_DIR:=$(BUILD_DIR)/Flask-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-flask
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=A microframework based on Werkzeug, Jinja2 and good intentions
  URL:=http://github.com/mitsuhiko/flask/
  DEPENDS:=+python3 +python3-werkzeug +python3-jinja2 +python3-itsdangerous
endef

define Package/python3-flask/description
 Flask
 Flask is a microframework for Python based on Werkzeug Jinja 2 and good
 intentions. And before you ask: Its BSD licensed
 Flask is Fun
 from flask import Flask
 app  Flask__name__
 64app.routequot/quot
 def hello:
     return quotHello Worldquot
 if __name__  quot__main__quot:
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

define Package/python3-flask/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-flask))
