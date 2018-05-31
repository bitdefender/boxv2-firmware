# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-pil
PKG_VERSION:=2.5.3
PKG_RELEASE:=1

PKG_SOURCE:=Pillow-2.5.3.zip
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/P/Pillow/
PKG_MD5SUM:=9879437c28ee0ad6ea04b93d0be2c2d7
PKG_BUILD_DIR:=$(BUILD_DIR)/Pillow-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-pil
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Python Imaging Library (Fork)
  URL:=http://python-pillow.github.io/
  DEPENDS:=+python3 +libjpeg +libfreetype +zlib +libtiff
endef

define Package/python3-pil/description
 Pillow
 Python Imaging Library Fork
 Pillow is the quotfriendlyquot PIL fork by Alex Clark and Contributors. PIL is the Python Imaging Library by Fredrik Lundh and Contributors. For more information please read the documentation.
 Changelog Pillow
 2.5.3 2014-08-18
 Fixed CVE-2014-3598 a DOS in the Jpeg2KImagePlugin
 Andrew Drake
 2.5.2 2014-08-13
 Fixed CVE-2014-3589 a DOS in the IcnsImagePlugin
 Andrew Drake
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

define Package/python3-pil/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/pilprint.py \
		$(1)/usr/bin/pilprint3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/pilprint3

	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/pilfont.py \
		$(1)/usr/bin/pilfont3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/pilfont3

	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/pilfile.py \
		$(1)/usr/bin/pilfile3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/pilfile3

	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/pildriver.py \
		$(1)/usr/bin/pildriver3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/pildriver3

	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/bin/pilconvert.py \
		$(1)/usr/bin/pilconvert3
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(1)/usr/bin/pilconvert3


endef

$(eval $(call BuildPackage,python3-pil))
