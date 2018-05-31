# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-django
PKG_VERSION:=1.7
PKG_RELEASE:=1

PKG_SOURCE:=Django-1.7.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/D/Django/
PKG_MD5SUM:=03edab6828119aa9b32b2252d25eb38d
PKG_BUILD_DIR:=$(BUILD_DIR)/Django-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-django
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=A high-level Python Web framework that encourages rapid development and clean, pragmatic design.
  URL:=http://www.djangoproject.com/
  DEPENDS:=+python3
endef

define Package/python3-django/description
 Django is a high-level Python Web framework that encourages rapid development
 and clean pragmatic design. Thanks for checking it out.
 All documentation is in the quotdocsquot directory and online at
 https://docs.djangoproject.com/en/stable/. If youre just getting started
 heres how we recommend you read the docs:
 First read docs/intro/install.txt for instructions on installing Django.
 Next work through the tutorials in order docs/intro/tutorial01.txt
 docs/intro/tutorial02.txt etc..
 If you want to set up an actual deployment server read
 docs/howto/deployment/index.txt for instructions.
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

define Package/python3-django/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/django-admin.py \
		$(1)/usr/bin/django-admin3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/django-admin3


endef

$(eval $(call BuildPackage,python3-django))
