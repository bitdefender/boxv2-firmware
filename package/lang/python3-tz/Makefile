# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-tz
PKG_VERSION:=2014.7
PKG_RELEASE:=1

PKG_SOURCE:=pytz-2014.7.tar.bz2
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/p/pytz/
PKG_MD5SUM:=5c1d3966406c6637b95d1eb2652cd8e1
PKG_BUILD_DIR:=$(BUILD_DIR)/pytz-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-tz
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=World timezone definitions, modern and historical
  URL:=http://pythonhosted.org/pytz
  DEPENDS:=+python3
endef

define Package/python3-tz/description
 pytz - World Timezone Definitions for Python
 Author:
 Stuart Bishop ltstuart64stuartbishop.netgt
 Introduction
 pytz brings the Olson tz database into Python. This library allows
 accurate and cross platform timezone calculations using Python 2.4
 or higher. It also solves the issue of ambiguous times at the end
 of daylight saving time which you can read more about in the Python
 Library Reference datetime.tzinfo.
 Almost all of the Olson timezones are supported.
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

define Package/python3-tz/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-tz))
