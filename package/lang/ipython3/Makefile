# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ipython3
PKG_VERSION:=2.2.0
PKG_RELEASE:=1

PKG_SOURCE:=ipython-2.2.0.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/i/ipython/
PKG_MD5SUM:=b91d3724f655a8e16d022772f696cfd5
PKG_BUILD_DIR:=$(BUILD_DIR)/ipython-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/ipython3
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=IPython: Productive Interactive Computing
  URL:=http://ipython.org
  DEPENDS:=+python3 +python3-setuptools +python3-doc
endef

define Package/ipython3/description
 IPython provides a rich toolkit to help you make the most out of using Python
 interactively.  Its main components are:
 Powerful interactive Python shells terminal- and Qt-based.
 A web-based interactive notebook environment with all shell features plus
 support for embedded figures animations and rich media.
 Support for interactive data visualization and use of GUI toolkits.
 Flexible embeddable interpreters to load into your own projects.
 A high-performance library for high level and interactive parallel computing
 that works in multicore systems clusters supercomputing and cloud scenarios.
 The enhanced interactive Python shells have the following main features:
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

define Package/ipython3/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/ipcluster3 \
		$(1)/usr/bin/ipcluster3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/ipcluster3

	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/ipcontroller3 \
		$(1)/usr/bin/ipcontroller3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/ipcontroller3

	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/ipengine3 \
		$(1)/usr/bin/ipengine3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/ipengine3

	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/iptest3 \
		$(1)/usr/bin/iptest3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/iptest3

	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/ipython3 \
		$(1)/usr/bin/ipython3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/ipython3


endef

$(eval $(call BuildPackage,ipython3))
