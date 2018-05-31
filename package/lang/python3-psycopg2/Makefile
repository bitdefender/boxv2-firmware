# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-psycopg2
PKG_VERSION:=2.5.4
PKG_RELEASE:=1

PKG_SOURCE:=psycopg2-2.5.4.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/p/psycopg2/
PKG_MD5SUM:=25216543a707eb33fd83aa8efb6e3f26
PKG_BUILD_DIR:=$(BUILD_DIR)/psycopg2-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-psycopg2
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Python-PostgreSQL Database Adapter
  URL:=http://initd.org/psycopg/
  DEPENDS:=+python3 +libpq
endef

define Package/python3-psycopg2/description
 psycopg2 is a PostgreSQL database adapter for the Python programming
 language.  psycopg2 was written with the aim of being very small and fast
 and stable as a rock.
 psycopg2 is different from the other database adapter because it was
 designed for heavily multi-threaded applications that create and destroy
 lots of cursors and make a conspicuous number of concurrent INSERTs or
 UPDATEs. psycopg2 also provide full asynchronous operations and support
 for coroutine libraries.
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

define Package/python3-psycopg2/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-psycopg2))
