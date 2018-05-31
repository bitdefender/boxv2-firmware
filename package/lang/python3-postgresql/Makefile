# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-postgresql
PKG_VERSION:=1.1.0
PKG_RELEASE:=1

PKG_SOURCE:=py-postgresql-1.1.0.zip
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/p/py-postgresql/
PKG_MD5SUM:=84478c6e7a36cb5e1e391217289b7e54
PKG_BUILD_DIR:=$(BUILD_DIR)/py-postgresql-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-postgresql
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=PostgreSQL driver and tools library.
  URL:=http://python.projects.postgresql.org/
  DEPENDS:=+python3 +libpq
endef

define Package/python3-postgresql/description
 Warning
 v1.1.0 requires Python 3.3 or the ipaddress module from 3.3 to be copied to the python3.2.
 py-postgresql is a set of Python modules providing interfaces to various parts
 of PostgreSQL. Notably it provides a pure-Python driver  C optimizations for
 querying a PostgreSQL database.
 http://python.projects.postgresql.org
 Features:
 Prepared Statement driven interfaces.
 Cluster tools for creating and controlling a cluster.
 Support for most PostgreSQL types: composites arrays numeric lots more.
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

define Package/python3-postgresql/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-postgresql))
