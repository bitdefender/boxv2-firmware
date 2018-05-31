# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-sqlalchemy
PKG_VERSION:=0.9.7
PKG_RELEASE:=1

PKG_SOURCE:=SQLAlchemy-0.9.7.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/S/SQLAlchemy/
PKG_MD5SUM:=e3c8f836ea9b48886718f59b9d8646ff
PKG_BUILD_DIR:=$(BUILD_DIR)/SQLAlchemy-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-sqlalchemy
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Database Abstraction Library
  URL:=http://www.sqlalchemy.org
  DEPENDS:=+python3
endef

define Package/python3-sqlalchemy/description
 SQLAlchemy
 The Python SQL Toolkit and Object Relational Mapper
 Introduction
 SQLAlchemy is the Python SQL toolkit and Object Relational Mapper
 that gives application developers the full power and
 flexibility of SQL. SQLAlchemy provides a full suite
 of well known enterprise-level persistence patterns
 designed for efficient and high-performing database
 access adapted into a simple and Pythonic domain
 language.
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

define Package/python3-sqlalchemy/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-sqlalchemy))
