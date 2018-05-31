# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-greenlet
PKG_VERSION:=0.4.4
PKG_RELEASE:=1

PKG_SOURCE:=greenlet-0.4.4.zip
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/g/greenlet/
PKG_MD5SUM:=1be0822a0b2467d0d08cf5d0224d965b
PKG_BUILD_DIR:=$(BUILD_DIR)/greenlet-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-greenlet
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Lightweight in-process concurrent programming
  URL:=https://github.com/python-greenlet/greenlet
  DEPENDS:=+python3 @BROKEN
endef

define Package/python3-greenlet/description
 The greenlet package is a spin-off of Stackless a version of CPython
 that supports micro-threads called quottaskletsquot. Tasklets run
 pseudo-concurrently typically in a single or a few OS-level threads
 and are synchronized with data exchanges on quotchannelsquot.
 A quotgreenletquot on the other hand is a still more primitive notion of
 micro-thread with no implicit scheduling coroutines in other
 words. This is useful when you want to control exactly when your code
 runs. You can build custom scheduled micro-threads on top of greenlet
 however it seems that greenlets are useful on their own as a way to
 make advanced control flow structures. For example we can recreate
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

define Package/python3-greenlet/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-greenlet))
